import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../utility/constants.dart';

class CaptureImage extends StatefulWidget {
  final Function(String) captureImage;

  const CaptureImage({super.key, required this.captureImage});

  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  String? imageUrl;
  bool loading = false;

  Future<void> captureAndUploadImage() async {
    setState(() {
      loading = true;
    });
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      //capture photo for generating fine and upload to the firebase 
      String filePath = 'fines/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File(image.path);

      try {
        await FirebaseStorage.instance.ref(filePath).putFile(file);
        String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
        print(downloadUrl);
        widget.captureImage(downloadUrl);
        setState(() {
          imageUrl = downloadUrl;// Store the image URL for display
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(imageUrl == null)
          ElevatedButton(
            onPressed: captureAndUploadImage,
            child: Text('Capture Photo',),
          ),
        if (imageUrl != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imageUrl!), // Display the captured image
          ),
        kBox,
        if(loading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.0),
            child: LinearProgressIndicator(
              color: kSecondaryColor,
              minHeight: 5.0,
            ),
          ),

      ],
    );
  }
}
