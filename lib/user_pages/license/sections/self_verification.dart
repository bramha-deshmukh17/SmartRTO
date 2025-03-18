import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utility/constants.dart';
import '../../../utility/round_button.dart';
import 'formdata.dart';

class SelfVerification extends StatefulWidget {
  final FormData formData;
  SelfVerification({required this.formData});
  @override
  _SelfVerificationState createState() => _SelfVerificationState();
}

class _SelfVerificationState extends State<SelfVerification> {
  File? _imageFile;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
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
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    width: 250,
                    height: 250,
                  )
                : Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(FontAwesomeIcons.image,
                        size: 50, color: Colors.grey),
                  ),

            //selfie error message
            widget.formData.fieldErrors['selfie'] != null
                ? Text(
                    'Upload selfie!',
                    style: TextStyle(color: kRed),
                  )
                : Container(),

            kBox,
            widget.formData.selfie == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundButton(
                        onPressed:
                            _imageFile == null ? _takeSelfie : _uploadSelfie,
                        text: _imageFile == null
                            ? 'Take a Selfie'
                            : 'Upload Selfie',
                      ),
                      SizedBox(width: 10),
                      _imageFile != null
                          ? RoundButton(onPressed: _retry, text: 'Retry')
                          : kBox,
                    ],
                  )
                : Text(
                    "Uploaded",
                    style: TextStyle(color: kGreen),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _takeSelfie() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _uploadSelfie() async {
    setState(() {
      isLoading = true;
    });
    String filePath =
        'llapplication/${DateTime.now().millisecondsSinceEpoch}_selfie.jpg';
    if (_imageFile != null) {
      await FirebaseStorage.instance.ref(filePath).putFile(_imageFile!);
    }
    String downloadUrl =
        await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    setState(() {
      widget.formData.selfie = downloadUrl;
      isLoading = false;
    });
  }

  void _retry() {
    setState(() {
      _imageFile = null;
    });
  }
}
