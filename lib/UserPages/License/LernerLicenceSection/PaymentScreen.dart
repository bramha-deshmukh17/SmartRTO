import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/Utility/RoundButton.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../Utility/Constants.dart';
import 'FormData.dart';

class PaymentScreen extends StatefulWidget {
  final FormData formData;
  PaymentScreen({required this.formData});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  Map<String, dynamic>? finesData; // Variable to store fetched fine data
  bool isLoading = true; // Variable to track loading state
  String? transactionId; // Variable to store transaction ID

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle failed payment
    print("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print("External Wallet: ${response.walletName}");
  }

  void openCheckout() async {
    var options = {
      'key': dotenv
          .env['RAZOR_PAY_API'], // Replace with your Razorpay Test API Key
      'amount': (100 * 100).toString(), // Convert to paisa
      'name': 'RTO India',
      'description': 'Payment for LL Application',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@example.com',
      },
    };

    try {
      print("Payment started");
      _razorpay.open(options);
      print("Payment finished");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Screen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        kBox,
        Center(
          child: Column(
            children: [
              Text(
                "Payment: 100 Rs.",
                style: TextStyle(fontSize: 16),
              ),
              kBox,
              Text(
                "Payment powered by Razorpay",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              kBox,
              Text(
                "Please ensure that your contact and email details are correct.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              kBox,
              RoundButton(onPressed: openCheckout, text: "Pay"),
              kBox,
              Text(
                "For any issues, contact support@example.com",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
