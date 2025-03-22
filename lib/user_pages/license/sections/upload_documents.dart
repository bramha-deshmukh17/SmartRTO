import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdfx/pdfx.dart';
import '../../../utility/constants.dart';
import 'formdata.dart';

class UploadDocuments extends StatefulWidget {
  final FormData formData;
  UploadDocuments({required this.formData});

  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  PdfController? _pdfAadhaarController, _pdfBillController;
  File? _selectedAadhaarPdf, _selectedBillPdf;
  bool isLoading = false;

  // Track whether files are uploaded
  bool isAadhaarUploaded = false;
  bool isBillUploaded = false;

  @override
  void dispose() {
    _pdfAadhaarController?.dispose();
    _pdfBillController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //upload the relevant docs
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
                color: kSecondaryColor,
                minHeight: 5.0,
              ),
            )
          else
            kBox,
          _buildPdfUploadSection(
            title: "Upload Aadhaar",
            isAadhaar: true,
            pdfController: _pdfAadhaarController,
            selectedFile: _selectedAadhaarPdf,
            onRetry: () => resetFile(true),
            onSubmit: () => uploadDoc(_selectedAadhaarPdf, true),
            errorText: widget.formData.fieldErrors['aadhaarPdf'],
            isFileUploaded: isAadhaarUploaded,
          ),
          kBox,
          _buildPdfUploadSection(
            title: 'Upload Address Proof (PAN/Light Bill, etc.)',
            isAadhaar: false,
            pdfController: _pdfBillController,
            selectedFile: _selectedBillPdf,
            onRetry: () => resetFile(false),
            onSubmit: () => uploadDoc(_selectedBillPdf, false),
            errorText: widget.formData.fieldErrors['billPdf'],
            isFileUploaded: isBillUploaded,
          ),
        ],
      ),
    );
  }

  Widget _buildPdfUploadSection({
    required String title,
    required bool isAadhaar,
    PdfController? pdfController,
    File? selectedFile,
    required VoidCallback onRetry,
    required VoidCallback onSubmit,
    required bool isFileUploaded,
    String? errorText,
  }) {
    String? uploadedFile =
        isAadhaar ? widget.formData.aadhaarPdf : widget.formData.billPdf;

    return Center(
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

          // Show uploaded file preview if available
          //here if thisi sdl form then the docs uploaded in the ll form are preloaded here and displayed here
          //also user can update them if they want
          //and if it is ll form then the user needs to upload the docs
          uploadedFile != null && uploadedFile.isNotEmpty
              ? FutureBuilder<PdfControllerPinch>(
                  future: _buildNetworkController(uploadedFile),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kSecondaryColor))),
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
              : selectedFile != null
                  ? SizedBox(
                      height: 250,
                      width: 250,
                      child: pdfController != null
                          ? PdfView(controller: pdfController)
                          : Center(child: Text("Error loading PDF")),
                    )
                  : Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(FontAwesomeIcons.file,
                            size: 50, color: Colors.grey),
                      ),
                    ),

          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          //if file is uploaded then the buttons are hidden and if not then showed
          //if file is selected for the upload then clear and submit buttons are visible else camera and gallery buttons are visible
          !isFileUploaded //if file is not uploaded
              ? Column(
                  children: [
                    selectedFile == null //if selected file is null
                        ? ElevatedButton.icon(
                            onPressed: () => _pickPdf(isAadhaar),
                            icon: Icon(FontAwesomeIcons.filePdf,
                                color: kSecondaryColor),
                            label: Text("Pick PDF",
                                style: TextStyle(color: kBlack)),
                          )
                        : ElevatedButton.icon(
                            onPressed: onSubmit,
                            icon: Icon(FontAwesomeIcons.upload,
                                color: kSecondaryColor),
                            label:
                                Text("Submit", style: TextStyle(color: kBlack)),
                          ),
                    selectedFile != null
                        ? ElevatedButton.icon(
                            onPressed: onRetry,
                            icon: Icon(FontAwesomeIcons.arrowsRotate,
                                color: kSecondaryColor),
                            label:
                                Text("Retry", style: TextStyle(color: kBlack)),
                          )
                        : kBox,
                  ],
                )
              : Text("Uploaded", style: TextStyle(color: kGreen)),
        ],
      ),
    );
  }

  Future<PdfControllerPinch> _buildNetworkController(String url) async {
    final data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return PdfControllerPinch(
        document: PdfDocument.openData(data.buffer.asUint8List()));
  }

  Future<void> _pickPdf(bool isAadhaar) async {
    //pick up pdf from the files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        //set file data
        if (isAadhaar) {
          _selectedAadhaarPdf = file;
          _pdfAadhaarController =
              PdfController(document: PdfDocument.openFile(file.path));
          widget.formData.aadhaarPdf = null;
          isAadhaarUploaded = false;
        } else {
          _selectedBillPdf = file;
          _pdfBillController =
              PdfController(document: PdfDocument.openFile(file.path));
          widget.formData.billPdf = null;
          isBillUploaded = false;
        }
      });
    }
  }

  Future<void> uploadDoc(File? file, bool isAadhaar) async {
    //upload the pdf
    setState(() {
      isLoading = true;
      //trigger the loading animation
    });

    try {
      //filepath  to store the file in the firebase
      String filePath =
          'llapplication/${DateTime.now().millisecondsSinceEpoch}_${isAadhaar ? "aadhaar" : "bill"}.pdf';

      if (file != null) {
        await FirebaseStorage.instance.ref(filePath).putFile(file);
      }

      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      setState(() {
        //update file upload status and store its url
        if (isAadhaar) {
          widget.formData.aadhaarPdf = downloadUrl;
          isAadhaarUploaded = true;
        } else {
          widget.formData.billPdf = downloadUrl;
          isBillUploaded = true;
        }
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  void resetFile(bool isAadhaar) {
    setState(() {
      //reset the file if user wants to change the reupload it 
      if (isAadhaar) {
        _selectedAadhaarPdf = null;
        _pdfAadhaarController?.dispose();
        _pdfAadhaarController = null;
        isAadhaarUploaded = false;
      } else {
        _selectedBillPdf = null;
        _pdfBillController?.dispose();
        _pdfBillController = null;
        isBillUploaded = false;
      }
    });
  }
}
