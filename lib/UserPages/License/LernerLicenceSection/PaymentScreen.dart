import 'package:flutter/material.dart';
import 'FormData.dart';

class PaymentScreen extends StatelessWidget {
  final FormData formData;
  PaymentScreen({required this.formData});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Payment Screen (Data: $formData)'),
          ElevatedButton(
            onPressed: () {
              // Perform payment logic here
              // After successful payment, navigate to receipt screen
             
            },
            child: Text('Make Payment'),
          ),
        ],
      ),
    );
  }
}
