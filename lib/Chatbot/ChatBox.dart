import 'package:flutter/material.dart';

import '../Utility/Constants.dart';

class ChatBox extends StatelessWidget {
  final VoidCallback filePressed;
  final dynamic controller;

  const ChatBox({super.key, required this.controller, required this.filePressed, });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: IconButton(
          onPressed: filePressed,
          icon: const Icon(Icons.upload_file,color: kSecondaryColor,),
        ),
        hintText: "Message",

        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kSecondaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kSecondaryColor, // Set the border color when the TextField is focused
            width: 2.0, // Set the border width
          ),
          borderRadius: BorderRadius.circular(30), // Optional: Rounded corners
        ),
      ),
    );
  }
}
