import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'Constants.dart';

class OTPField extends StatelessWidget {
  final dynamic controller;

  const OTPField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return  PinCodeTextField(
      appContext: context,
      length: 6,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: (v) {
        if (v!.length < 6) {
          return "Enter valid OTP!";
        } else {
          return null;
        }
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        activeColor: kSecondaryColor,
        inactiveColor: kPrimaryColor,
        selectedColor: kSecondaryColor,
      ),
      cursorColor: Colors.black,
      controller: controller,
      keyboardType: TextInputType.number,
      boxShadows: const [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onChanged: (value) {},
    );
  }
}
