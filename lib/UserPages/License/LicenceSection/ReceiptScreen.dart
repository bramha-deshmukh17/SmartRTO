import 'package:flutter/material.dart';
import 'package:mobile/Utility/Constants.dart';
import 'FormData.dart';

class ReceiptScreen extends StatelessWidget {
  final FormData formData;
  ReceiptScreen({required this.formData});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Text(
            'Receipt ID: ${this.formData.receiptId}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue),
            ),
            kBox,
            Text(
            'Full Name: ${this.formData.fullNameController.text}',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black),
            ),
            kBox,
            Text(
            'Mobile: ${this.formData.applicantMobileController.text}',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black),
            ),
            kBox,
            Text(
            'Payment Date: ${this.formData.payementDate.toString()}',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black),
            ),
            kBox,
            Text(
            'Please visit the nearby RTO office for the online exam with the original set of documents shared while filing the form.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.red),
            textAlign: TextAlign.center,
            ),

        ],
      ),
    );
  }
}
