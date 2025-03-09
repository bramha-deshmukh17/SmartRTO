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
  int fees = 50;
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
    setState(() {
      widget.formData.paymentId = response.paymentId!;
      widget.formData.payementDate = DateTime.now();
    });
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
      'amount': (fees * 100).toString(), // Convert to paisa
      'name': 'RTO India',
      'description': 'Payment for LL Application',
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
    
    fees = (widget.formData.selectedVehicleClasses.length * 150) + 50;

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
                "Payment: ${fees} Rs.",
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
              if (widget.formData.fieldErrors['paymentId'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.formData.fieldErrors['paymentId']!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
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
