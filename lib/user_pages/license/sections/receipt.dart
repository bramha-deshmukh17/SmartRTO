import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utility/constants.dart';
import 'formdata.dart';

class ReceiptScreen extends StatelessWidget {
  final FormData formData;
  ReceiptScreen({required this.formData});
  @override
  Widget build(BuildContext context) {
    //show the receipt for the license application
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receipt ID: ${this.formData.receiptId}',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.copy,
                ),
                onPressed: () {
                  // Copy label text to clipboard
                  Navigator.pop(context);
                  Clipboard.setData(
                      ClipboardData(text: this.formData.receiptId.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!')),
                  );
                },
              ),
            ],
          ),
          kBox,
          Text(
            'Full Name: ${this.formData.fullNameController.text}',
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          kBox,
          Text(
            'Mobile: ${this.formData.applicantMobileController.text}',
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          kBox,
          Text(
            'Payment Date: ${this.formData.payementDate.toString()}',
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          kBox,
          Text(
            this.formData.isDrivingApplication
                ? 'Please visit the nearby RTO office for the driving exam with the original set of documents shared while filling the form.'
                : 'Please visit the nearby RTO office for the online exam with the original set of documents shared while filling the form.',
            style: TextStyle(fontSize: 14.0, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
