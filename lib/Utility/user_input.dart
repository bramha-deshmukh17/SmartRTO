import 'package:flutter/material.dart';

import 'constants.dart';

class UserInput  extends StatelessWidget {
  final String hint;
  final dynamic maxLength;
  final dynamic keyboardType;
  final dynamic controller;
  final dynamic errorText;
  final dynamic submit;
  final dynamic focusNode;
  final dynamic maxlines;
  final dynamic readonly;
  final dynamic textAlignment;
  final dynamic width;


  const UserInput({super.key, required this.controller, required this.hint, this.focusNode, this.submit, required this.keyboardType, this.maxLength, this.errorText, this.maxlines, this.readonly=false, this.textAlignment=TextAlign.center, this.width=250.0});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
      child: TextField(
        enabled: true,
        readOnly: readonly,
        focusNode: focusNode,
        textAlign: textAlignment,
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxlines,
        style: const TextStyle(fontFamily: 'InriaSans',fontSize: 20.0),
        cursorColor: kBlack,
      
        onSubmitted: submit,

        decoration: InputDecoration(
          labelText: hint,
          errorText: errorText,
          labelStyle: TextStyle(color: kBlack),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: kSecondaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
                color: kSecondaryColor, width: 1.0), // Default state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
                color: kSecondaryColor, width: 2.0), // Focused state
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: Colors.red, width: 2.0), // Error state
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
                color: Colors.red, width: 2.0), // Error focused state
          ),
        ),
      ),
    );
  }
}
