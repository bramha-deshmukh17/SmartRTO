import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/Utility/Constants.dart';
import 'FormData.dart';

class UploadPhotoAndSign extends StatefulWidget {
  final FormData formData;
  UploadPhotoAndSign({required this.formData});

  @override
  _UploadPhotoAndSignState createState() => _UploadPhotoAndSignState();
}

class _UploadPhotoAndSignState extends State<UploadPhotoAndSign> {
  File? _photo;
  File? _signature;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Photo & Signature",
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
          else
            kBox,

          // Photo Upload Section
          _buildUploadSection(
            title: "Upload Photo",
            file: _photo,
            onCameraTap: () => _pickImage(ImageSource.camera, true),
            onGalleryTap: () => _pickImage(ImageSource.gallery, true),
            retry: () => retry(_photo!, true),
            errorText: widget.formData.fieldErrors['photo'],
            submit: () => uploadDoc(_photo, true),
          ),

          SizedBox(height: 20),

          // Signature Upload Section
          _buildUploadSection(
              title: "Upload Signature",
              file: _signature,
              onCameraTap: () => _pickImage(ImageSource.camera, false),
              onGalleryTap: () => _pickImage(ImageSource.gallery, false),
              retry: () => retry(_signature!, false),
              errorText: widget.formData.fieldErrors['signature'],
              submit: () => uploadDoc(_signature, false)),
        ],
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required File? file,
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    required VoidCallback retry,
    required VoidCallback submit,
    String? errorText,
  }) {
    String fileUpload = title == "Upload Photo"
        ? widget.formData.photo
        : widget.formData.signature;
    print(fileUpload);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          fileUpload == null
              ? file != null
                  ? Image.file(
                      file,
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    )
                  : Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(FontAwesomeIcons.image,
                          size: 50, color: Colors.grey),
                    )
              : Image.network(
                  fileUpload,
                  height: 150,
                  width: 150,
                  fit: BoxFit.fill,
                ),
          kBox,
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          fileUpload == null 
              ? file == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: onCameraTap,
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            color: kSecondaryColor,
                          ),
                          label: Text(
                            "Camera",
                            style: TextStyle(color: kBlack),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: onGalleryTap,
                          icon: Icon(
                            FontAwesomeIcons.image,
                            color: kSecondaryColor,
                          ),
                          label: Text(
                            "Gallery",
                            style: TextStyle(color: kBlack),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: retry,
                          icon: Icon(
                            FontAwesomeIcons.arrowsRotate,
                            color: kSecondaryColor,
                          ),
                          label: Text(
                            "Retry",
                            style: TextStyle(color: kBlack),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
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

  Future<void> _pickImage(ImageSource source, bool isPhoto) async {
    final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80); //get the image from source i.e. gallery or camera

    if (pickedFile != null) {
      setState(() {
        if (isPhoto) {
          _photo = File(pickedFile.path);
        } else {
          _signature = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> uploadDoc(File? file, bool photo) async {
    setState(() {
      isLoading = true;
    });
    if (photo) {
      String filePath =
          'llapplication/${DateTime.now().millisecondsSinceEpoch}_photo.jpg';
      if (_photo != null) {
        await FirebaseStorage.instance.ref(filePath).putFile(_photo!);
      }
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      setState(() {
        widget.formData.photo = downloadUrl;
      });
    } else {
      String filePath =
          'llapplication/${DateTime.now().millisecondsSinceEpoch}_sign.pdf';
      if (_signature != null) {
        await FirebaseStorage.instance.ref(filePath).putFile(_signature!);
      }
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      setState(() {
        widget.formData.signature = downloadUrl;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void retry(File file, bool isPhoto) {
    setState(() {
      if (isPhoto) {
        _photo = null;
      } else {
        _signature = null;
      }
    });
  }
}
