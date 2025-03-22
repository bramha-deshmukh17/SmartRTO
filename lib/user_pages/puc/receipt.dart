import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utility/constants.dart';
import '../../utility/appbar.dart';

class ReceiptScreen extends StatefulWidget {
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String? receiptId, fullname, applicantMobile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      receiptId = args['receiptId'] ?? '';
      fullname = args['fullname'] ?? '';
      applicantMobile = args['applicantMobile'] ?? '';
    } else {
      print("Error: Received unexpected arguments: $args");
    }

  }


  @override
  Widget build(BuildContext context) {
    //receipt for pucapplication
    return Scaffold(
      appBar: Appbar(title: 'PUC Receipt',isBackButton: true, displayUserProfile: true),
      body:  Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receipt ID: ${receiptId}',
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
                        ClipboardData(text: receiptId.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
            kBox,
            Text(
              'Full Name: ${fullname}',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            kBox,
            Text(
              'Mobile: ${applicantMobile}',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            kBox,
          ],
        ),
      ),
    );
  }
}
