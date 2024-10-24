import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utility/Constants.dart';

class PaymentPage extends StatefulWidget {
  final String licensePlate; // License plate for querying

  const PaymentPage({super.key, required this.licensePlate});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
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
    fetchFineData(); // Fetch fine data on initialization
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchFineData() async {
    try {
      // Fetch fine data from Firestore using the 'where' method
      QuerySnapshot snapshot = await _firestore
          .collection('fines') // Replace 'fines' with your collection name
          .where('to', isEqualTo: widget.licensePlate) // Filter by license plate
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the first document and its data
        finesData = snapshot.docs.first.data() as Map<String, dynamic>;
        finesData!['documentId'] = snapshot.docs.first.id; // Store document ID for future updates
      } else {
        finesData = null; // No fine data found
      }
    } catch (e) {
      print("Error fetching fine data: $e");
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Handle successful payment
    print("Payment Successful: ${response.paymentId}");

    // Update Firestore document if finesData is not null
    if (finesData != null) {
      String documentId = finesData!['documentId']; // Document ID
      await _firestore.collection('fines').doc(documentId).update({
        'status': 'Paid',  // Update payment status to Completed
        'transaction_id': response.paymentId,  // Store payment ID in transaction_id
      }).then((_) {
        print("Document updated successfully");
        setState(() {
          finesData!['status'] = 'Paid'; // Update local status for UI refresh
          transactionId = response.paymentId; // Store the transaction ID for display
        });
      }).catchError((error) {
        print("Error updating document: $error");
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle failed payment
    print("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print("External Wallet: ${response.walletName}");
  }

  void openCheckout(double totalFine) async {
    var options = {
      'key': dotenv.env['RAZOR_PAY_API'], // Replace with your Razorpay Test API Key
      'amount': (totalFine * 100).toString(), // Convert to paisa
      'name': 'RTO India',
      'description': 'Payment for Fines',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@example.com',
      },
      'external': {
        'wallets': ['paytm'], // Add external wallets if required
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    if (finesData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("No Fines Found"),
        ),
        body: const Center(child: Text("No fine data available for this license plate.")),
      );
    }

    final fines = finesData!['fines'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: kBackArrow,
        ),
        title: kAppBarTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the fine-related photo (if available)
            Image.network(
              finesData!['photo'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, size: 100),
            ),
            const SizedBox(height: 16),

            // Display license plate and issued by
            Text(
              'License Plate: ${finesData!['to']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Issued By: ${finesData!['by']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Display total fine amount
            Text(
              'Total Fine: ₹${finesData!['total']}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Display the payment status
            Text(
              'Status: ${finesData!['status']}',
              style: TextStyle(
                fontSize: 18,
                color: finesData!['status'] == 'Pending'
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            // Display transaction ID if payment is completed
            if (finesData!['transaction_id'] != null)
              Text(
                'Transaction ID: ${finesData!["transaction_id"]}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 16),

            // List of individual fines
            const Text(
              'Fines:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: fines.length,
                itemBuilder: (context, index) {
                  final entry = fines.entries.elementAt(index);
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Text(
                      '₹${entry.value}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),

            // "Pay Now" button to redirect to the payment gateway
            if (finesData!['status'] == 'Pending') // Show button only if status is Pending
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    double totalFine = double.tryParse(finesData!['total'].toString()) ?? 0.0;
                    print(totalFine);
                    openCheckout(totalFine); // Open Razorpay checkout
                  },
                  child: const Text("Pay Now"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
