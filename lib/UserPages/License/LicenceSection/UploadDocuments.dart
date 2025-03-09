import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdfx/pdfx.dart';
import '../../../Utility/Constants.dart';
import 'FormData.dart';

class UploadDocuments extends StatefulWidget {
  final FormData formData;
  UploadDocuments({required this.formData});

  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  PdfController? _pdfAdhaarController, _pdfBillController;
  File? _selectedAdhaarPdf, _selectedBillPdf;
  bool isLoading = false;

  @override
  void dispose() {
    _pdfAdhaarController?.dispose();
    _pdfBillController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Aadhaar and Light Bill',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),


          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                minHeight: 5.0,
              ),
            )
          else kBox,


          createPdfView(
              title: "Upload Aadhaar",
              adhaar: true,
              pdfController: _pdfAdhaarController,
              selectedFile: _selectedAdhaarPdf,
              callBack: () => setState(() {
                    _selectedAdhaarPdf = null;
                    _pdfAdhaarController?.dispose();
                    _pdfAdhaarController = null;
                  }),
              errorText: widget.formData.fieldErrors['aadhaarPdf'],
              submit: () => uploadDoc(_selectedAdhaarPdf, true),
          ),
          kBox,
          createPdfView(
            title: 'Upload Address proof(PAN/Light bill, etc.)',
            adhaar: false,
            pdfController: _pdfBillController,
            selectedFile: _selectedBillPdf,
            callBack: () => setState(() {
              _selectedBillPdf = null;
              _pdfBillController?.dispose();
              _pdfBillController = null;
            }),
            errorText: widget.formData.fieldErrors['billPdf'],
            submit: () => uploadDoc(_selectedBillPdf, false),
          ),
        ],
      ),
    );
  }

Widget createPdfView({
    required String title,
    required bool adhaar,
    PdfController? pdfController, // For local file preview if available.
    File? selectedFile,
    required VoidCallback callBack,
    String? errorText,
    required VoidCallback submit,
  }) {
    // Determine which file URL to use based on the adhaar flag.
    // (Assuming widget.formData is accessible in your context.)
    String? fileUpload =
        adhaar ? widget.formData.aadhaarPdf : widget.formData.billPdf;

    return Center(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          // If an uploaded file URL is available, show the network PDF preview.
          fileUpload != null && fileUpload.isNotEmpty
              ? FutureBuilder<PdfControllerPinch>(
                  future: _buildNetworkController(fileUpload),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(child: Text("Error loading PDF")),
                      );
                    } else {
                      return SizedBox(
                        height: 250,
                        width: 250,
                        child: PdfViewPinch(controller: snapshot.data!),
                      );
                    }
                  },
                )
              : (selectedFile != null
                  // If no uploaded URL but a local file is selected, show its preview.
                  ? SizedBox(
                      height: 250,
                      width: 250,
                      child: pdfController != null
                          ? PdfView(controller: pdfController)
                          : Center(child: Text("Error loading PDF")),
                    )
                  // Otherwise, show a placeholder icon.
                  : Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          FontAwesomeIcons.file,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    )),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          // If no file is uploaded, show action buttons.
          fileUpload == null || fileUpload.isEmpty
              ? Column(
                  children: [
                    selectedFile == null
                        ? ElevatedButton.icon(
                            onPressed: () => _pickPdf(adhaar),
                            icon: Icon(
                              FontAwesomeIcons.filePdf,
                              color: kSecondaryColor,
                            ),
                            label: Text(
                              "Pick PDF",
                              style: TextStyle(color: kBlack),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: submit,
                            icon: Icon(
                              FontAwesomeIcons.upload,
                              color: kSecondaryColor,
                            ),
                            label: Text(
                              "Submit",
                              style: TextStyle(color: kBlack),
                            ),
                          ),
                    selectedFile != null
                        ? ElevatedButton.icon(
                            onPressed: callBack,
                            icon: Icon(
                              FontAwesomeIcons.arrowsRotate,
                              color: kSecondaryColor,
                            ),
                            label: Text(
                              "Retry",
                              style: TextStyle(color: kBlack),
                            ),
                          )
                        : kBox,
                  ],
                )
              : Text(
                  "Uploaded",
                  style: TextStyle(color: kGreen),
                ),
        ],
      ),
    );
  }

// Helper function to create a PdfControllerPinch from a network URL.
  Future<PdfControllerPinch> _buildNetworkController(String url) async {
    final data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return PdfControllerPinch(document: PdfDocument.openData(data.buffer.asUint8List()));
  }

  Future<void> _pickPdf(bool adhaar) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        if (adhaar) {
          _selectedAdhaarPdf = file;
          _pdfAdhaarController =
              PdfController(document: PdfDocument.openFile(file.path));
          widget.formData.aadhaarPdf = null;
        } else {
          _selectedBillPdf = file;
          _pdfBillController =
              PdfController(document: PdfDocument.openFile(file.path));
          widget.formData.billPdf = null;
        }
      });
    }
  }

  Future<void> uploadDoc(File? file, bool aadhaar) async {
    setState(() {
      isLoading = true;
    });
    if (aadhaar) {
      String filePath =
          'llapplication/${DateTime.now().millisecondsSinceEpoch}_aadhaar.pdf';
      if (_selectedAdhaarPdf != null) {
        await FirebaseStorage.instance
            .ref(filePath)
            .putFile(_selectedAdhaarPdf!);
      }
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      setState(() {
        widget.formData.aadhaarPdf = downloadUrl;
      });
    } else {
      String filePath =
          'llapplication/${DateTime.now().millisecondsSinceEpoch}_sign.pdf';
      if (_selectedAdhaarPdf != null) {
        await FirebaseStorage.instance.ref(filePath).putFile(_selectedBillPdf!);
      }
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      setState(() {
        widget.formData.billPdf = downloadUrl;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
