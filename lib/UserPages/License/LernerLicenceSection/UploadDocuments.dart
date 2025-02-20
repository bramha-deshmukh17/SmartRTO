import 'package:flutter/material.dart';
import 'FormData.dart';

class UploadDocuments extends StatelessWidget {
  final FormData formData;
  UploadDocuments({required this.formData});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Upload Documents'));
  }
}
