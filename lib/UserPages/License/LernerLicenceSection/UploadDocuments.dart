import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
        } else {
          _selectedBillPdf = file;
          _pdfBillController =
              PdfController(document: PdfDocument.openFile(file.path));
        }
      });
    }
  }

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
          kBox,
          createPdfView(
              "Upload Aadhaar",
              true,
              _pdfAdhaarController,
              _selectedAdhaarPdf,
              () => setState(() {
                    _selectedAdhaarPdf = null;
                    _pdfAdhaarController?.dispose();
                    _pdfAdhaarController = null;
                  })),
          kBox,
          createPdfView(
              'Upload Light Bill',
              false,
              _pdfBillController,
              _selectedBillPdf,
              () => setState(() {
                    _selectedBillPdf = null;
                    _pdfBillController?.dispose();
                    _pdfBillController = null;
                  })),
        ],
      ),
    );
  }

  Widget createPdfView(String title, bool adhaar, PdfController? pdfController,
      File? selectedFile, VoidCallback callBack) {
    return Center(
        child: Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        selectedFile == null
            ? Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(FontAwesomeIcons.file, size: 50, color: Colors.grey),
                ),
              )
            : Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: pdfController != null
                      ? PdfView(controller: pdfController)
                      : Center(child: Text("Error loading PDF")),
                ),
              ),
        ElevatedButton.icon(
          onPressed: () => _pickPdf(adhaar),
          icon: Icon(
            FontAwesomeIcons.filePdf,
            color: kSecondaryColor,
          ),
          label: Text(
            "Pick PDF",
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
    ));
  }
}
