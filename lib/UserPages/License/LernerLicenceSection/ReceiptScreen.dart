import 'package:flutter/material.dart'; 
import 'FormData.dart';

class ReceiptScreen extends StatelessWidget {
  final FormData formData;
  ReceiptScreen({required this.formData});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Receipt Screen (Data: $formData)'),
          // Display receipt details
        ],
      ),
    );
  }
}
