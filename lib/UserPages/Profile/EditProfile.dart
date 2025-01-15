import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '/Utility/Constants.dart';
import '/Utility/RoundButton.dart';
import '/Utility/UserInput.dart';

class EditUserProfile extends StatefulWidget {
  static const String id = "EditUserProfile";

  final String userName, userEmail, userImg, userMobile;

  const EditUserProfile({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userImg,
    required this.userMobile,
  });

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;

  final _nodeEmail = FocusNode();
  final _nodePassword = FocusNode();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    emailController = TextEditingController(text: widget.userEmail);
    mobileController = TextEditingController(text: widget.userMobile);
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Select Image From',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      FontAwesomeIcons.camera,
                      color: kSecondaryColor,
                    ),
                    label: const Text(
                      'Camera',
                      style: TextStyle(
                          color: kSecondaryColor, fontFamily: 'InriaSans'),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Close the modal
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          _imageFile = File(pickedFile.path);
                        });
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      FontAwesomeIcons.image,
                      color: kSecondaryColor,
                    ),
                    label: const Text(
                      'Gallery',
                      style: TextStyle(
                          color: kSecondaryColor, fontFamily: 'InriaSans'),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Close the modal
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _imageFile = File(pickedFile.path);
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return widget.userImg;

    setState(() {
      isUploading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await storageRef.putFile(_imageFile!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    String? imageUrl = await _uploadImage();

    if (imageUrl != null && nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      try {
        // Fetch the document where the mobile matches
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('mobile',
                isEqualTo: widget.userMobile) // Query by mobile number
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update the user details in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(querySnapshot.docs.first.id) // Use the found document ID
              .update({
            'name': nameController.text,
            'email': emailController.text,
            'img': imageUrl,
          });

          print('User details updated successfully!');
        } else {
          print('No user found with the provided mobile number.');
        }
      } catch (e) {
        print('Error updating user details: $e');
      }

      Navigator.pop(context, {
        'userName': nameController.text,
        'userEmail': emailController.text,
        'userImg': imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: kBackArrow,
        ),
        title: kAppBarTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage(widget.userImg),
                  child: _imageFile == null
                      ? const Icon(FontAwesomeIcons.camera,
                          size: 30, color: Colors.white)
                      : null,
                ),
              ),
              kBox,
              UserInput(
                controller: nameController,
                hint: 'Name',
                keyboardType: TextInputType.text,
                submit: (_) {
                  // Move focus to the second TextField
                  FocusScope.of(context).requestFocus(_nodeEmail);
                },
              ),
              kBox,
              UserInput(
                controller: emailController,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                focusNode: _nodeEmail,
                submit: (_) {
                  // Move focus to the second TextField
                  FocusScope.of(context).requestFocus(_nodePassword);
                },
              ),
              kBox,
              UserInput(
                controller: mobileController,
                readonly: true,
                hint: 'Mobile',
                keyboardType: TextInputType.phone,
                focusNode: _nodePassword,
                submit: (value) {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                },
              ),
              kBox,
              isUploading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          kSecondaryColor), // Set custom color
                    )
                  : RoundButton(onPressed: _saveProfile, text: 'Save')
            ],
          ),
        ),
      ),
    );
  }
}
