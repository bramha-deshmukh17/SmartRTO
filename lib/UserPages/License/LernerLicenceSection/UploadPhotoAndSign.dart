import 'package:flutter/material.dart';
import 'FormData.dart';

class UploadPhotoAndSign extends StatelessWidget {
  final FormData formData;
  UploadPhotoAndSign({required this.formData});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Upload Photo and Sign'));
  }
}
