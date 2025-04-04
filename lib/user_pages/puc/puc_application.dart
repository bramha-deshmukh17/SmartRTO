import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:mobile/utility/user_input.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import 'receipt.dart';

class PucApplication extends StatefulWidget {
  static const String id = 'user/puc/application';

  const PucApplication({super.key});

  @override
  State<PucApplication> createState() => PucApplicationState();
}

class PucApplicationState extends State<PucApplication> {
  int currentStep = 0;
  List<String> stateList = [];
  List<String> districtList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController chasisController = TextEditingController();
  Map<String, dynamic>? arguments;

  String? selectedState,
      selectedDistrict,
      paymentId,
      receiptId,
      selectedSlot,
      slot_no,
      slot_id;
  int? slotNo;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchSlots();
    fetchStates();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful: ${response.paymentId}");
    setState(() {
      paymentId = response.paymentId!;
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
    //open razorpay gateway
    var options = {
      'key': dotenv
          .env['RAZOR_PAY_API'], // Replace with your Razorpay Test API Key
      'amount': (100 * 100).toString(), // Convert to paisa
      'name': 'RTO India',
      'description': 'Payment for PUC Application',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fetch all states (document IDs from the 'states' collection)
  Future<void> fetchStates() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('states').get();
    List<String> states = snapshot.docs.map((doc) => doc.id).toList()..sort();
    setState(() {
      stateList = states;
    });
    if (selectedState != null) {
      fetchDistricts(selectedState!);
    }
  }

  // Fetch districts for the selected state from its document
  Future<void> fetchDistricts(String state) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('states').doc(state).get();
    if (docSnapshot.exists) {
      List<dynamic> districts = docSnapshot.get('districts');
      setState(() {
        districtList = districts.map((d) => d.toString()).toList();
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchSlots() async {
    final now = DateTime.now();
    final todayStart =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final querySnapshot = await _firestore
        .collection('puc_slots')
        .where('date', isGreaterThanOrEqualTo: todayStart)
        .orderBy('date', descending: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      return [
        {'id': doc.id, ...doc.data()}
      ];
    }
    return [];
  }

  void selectSlot(int slotNo, String slotId) {
    setState(() {
      slot_no = slotNo == 1 ? 'slot1' : 'slot2';
      slot_id = slotId;
      selectedSlot = slotId + (slotNo == 1 ? '_1' : '_2'); // Unique identifier
    });
  }

  @override
  Widget build(BuildContext context) {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //auto fill user mobile number 
    mobileController.text = arguments!['mobile'];

    return Scaffold(
      appBar: Appbar(
        title: 'PUC Application',
        displayUserProfile: true,
        isBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Column(
          children: [
            FillApplicationForm(),

            // Payment Section
            Text(
              'Payment Screen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            kBox,

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

            if (paymentId == null)
              RoundButton(onPressed: openCheckout, text: "Pay"),
            kBox,

            Text(
              "For any issues, contact support@example.com",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            kBox,

            RoundButton(
              onPressed: () async {
                if (validateFormFields()) {
                  if (await saveFormData()) {
                    bookSlot();
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptScreen(),
                          settings: RouteSettings(
                              arguments: {
                            'receiptId': receiptId,
                            'fullname':  fullNameController.text,
                            'applicantMobile': mobileController.text,
                          }),
                        ),
                      );
                    }
                  }
                }
              },
              text: 'Submit',
            ),
          ],
        ),
      ),
    );
  }

  Widget FillApplicationForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Dropdown for State
          DropdownButtonFormField<String>(
            decoration: kDropdown("State"),
            value: selectedState,
            items: stateList.map((state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedState = newValue;
                selectedDistrict = null;
                districtList = [];
              });
              if (newValue != null) {
                fetchDistricts(newValue);
              }
            },
          ),
          kBox,

          // Dropdown for District
          DropdownButtonFormField<String>(
            decoration: kDropdown("District"),
            value: districtList.contains(selectedDistrict)
                ? selectedDistrict
                : null,
            items: districtList.map((district) {
              return DropdownMenuItem<String>(
                value: district,
                child: Text(district),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedDistrict = newValue;
              });
            },
          ),
          kBox,

          UserInput(
            controller: pinCodeController,
            hint: 'Pincode',
            keyboardType: TextInputType.number,
            maxLength: 6,
            width: double.infinity,
          ),
          kBox,

          UserInput(
            controller: fullNameController,
            hint: 'Full Name',
            keyboardType: TextInputType.text,
            textAlignment: TextAlign.start,
            width: double.infinity,
          ),
          kBox,

          UserInput(
            controller: mobileController,
            hint: 'Mobile',
            keyboardType: TextInputType.number,
            textAlignment: TextAlign.start,
            width: double.infinity,
            readonly: true,
          ),
          kBox,

          UserInput(
            controller: registrationController,
            hint: 'Registration Number',
            keyboardType: TextInputType.text,
            textAlignment: TextAlign.start,
            width: double.infinity,
          ),
          kBox,

          UserInput(
            controller: chasisController,
            hint: 'Chasis Number',
            keyboardType: TextInputType.text,
            textAlignment: TextAlign.start,
            width: double.infinity,
          ),
          kBox,

          //Slot selection
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSlots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: kSecondaryColor,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error fetching slots'));
              }

              final slots = snapshot.data ?? [];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    slots.isEmpty
                        ? Center(child: Text('No slots available'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: slots.length,
                            itemBuilder: (context, index) {
                              final slot = slots[index];

                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              (slot['date'] as Timestamp)
                                                  .toDate()),
                                          style: TextStyle(
                                              fontSize: 18.0, color: kGreen),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: slot['slot1']['remaining'] >
                                                0
                                            ? () => selectSlot(1, slot['id'])
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: selectedSlot ==
                                                  '${slot['id']}_1'
                                              ? kSecondaryColor // Highlighted color
                                              : kWhite, // Default color
                                        ),
                                        child: ListTile(
                                          title: Text('Slot 1: Morning 10AM'),
                                          subtitle: Text(
                                            '${slot['slot1']['remaining']} remaining',
                                            style: TextStyle(
                                              color:
                                                  slot['slot1']['remaining'] > 0
                                                      ? kGreen
                                                      : kRed,
                                            ),
                                          ),
                                        ),
                                      ),
                                      kBox,
                                      ElevatedButton(
                                        onPressed: slot['slot2']['remaining'] >
                                                0
                                            ? () => selectSlot(2, slot['id'])
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: selectedSlot ==
                                                  '${slot['id']}_2'
                                              ? kSecondaryColor // Highlighted color
                                              : kWhite, // Default color
                                        ),
                                        child: ListTile(
                                          title: Text('Slot 2: Afternoon 2PM'),
                                          subtitle: Text(
                                            '${slot['slot2']['remaining']} remaining',
                                            style: TextStyle(
                                              color:
                                                  slot['slot2']['remaining'] > 0
                                                      ? kGreen
                                                      : kRed,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              );
            },
          ),
          kBox,
        ],
      ),
    );
  }

  bool validateFormFields() {
    bool isValid = true;
    if (selectedState == null) {
      isValid = false;
    }
    if (selectedDistrict == null) {
      isValid = false;
    }
    // Pincode Validation
    if (pinCodeController.text.isEmpty) {
      isValid = false;
    }

    // Personal Details Validation
    if (fullNameController.text.isEmpty) {
      isValid = false;
    }

    if (mobileController.text.isEmpty) {
      isValid = false;
    }

    if (chasisController.text.isEmpty) {
      isValid = false;
    }

    if (registrationController.text.isEmpty) {
      isValid = false;
    }

    if (selectedSlot == null) {
      isValid = false;
    }

    if (paymentId == null) {
      isValid = false;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Fill all required fields.'),
          backgroundColor: kRed,
        ),
      );
    }
    return isValid;
  }

  Future<bool> saveFormData() async {
    try {
      receiptId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection('pucapplication').doc(receiptId).set({
        'selectedState': selectedState,
        'selectedDistrict': selectedDistrict,
        'pinCode': pinCodeController.text,
        'fullName': fullNameController.text,
        'mobile': mobileController.text,
        'registration': registrationController.text,
        'chasis': chasisController.text,
        'paymentId': paymentId,
        'receiptId': receiptId,
        'slot_no': slot_no,
        'slot_id': slot_id,
        'createdAt': FieldValue.serverTimestamp(),
        'approved':false,
      });

      print("Form saved successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted.'),
          backgroundColor: kGreen,
        ),
      );
      return true; // ✅ Now it properly returns true
    } catch (error) {
      print("Failed to save form: $error");
      return false;
    }
  }


  Future<void> bookSlot() async {
    try {
      String slot = slot_no ?? 'slot1';
      await _firestore.collection('puc_slots').doc(slot_id).update({
        '$slot.applicationsId': FieldValue.arrayUnion([receiptId]),
        '$slot.remaining': FieldValue.increment(-1),
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking slot: $error'),
          backgroundColor: kRed,
        ),
      );
    }
  }
}
