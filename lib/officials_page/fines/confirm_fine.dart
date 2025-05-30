import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';

class Confirmfine extends StatefulWidget {
  static const String id = 'officer/fine/confirm';

  const Confirmfine({super.key});

  @override
  State<Confirmfine> createState() => _ConfirmfineState();
}

class _ConfirmfineState extends State<Confirmfine> {
  late Map<String, int> fines;
  late int total;
  String? number, imgUrl, officerId;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userEmail;

  Future<void> getOfficerData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });

      try {
        // Fetch the officer's data using the email
        QuerySnapshot officerSnapshot = await _firestore
            .collection('officials')
            .where('email', isEqualTo: userEmail)
            .get();

        // Assuming that email is unique, we can take the first document
        DocumentSnapshot officerDoc = officerSnapshot.docs.first;

        setState(() {
          officerId = officerDoc.id;
        });
      } catch (e) {
        print('Error fetching officer data: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  void initState() {
    super.initState();
    getOfficerData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //getting fines data collected from generate fines screen
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    fines = arguments['fines'];
    total = arguments['total'];
    number = arguments['number'];
    imgUrl = arguments['imgUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Confirm Fine',
        isBackButton: true,
        displayOfficerProfile: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              kBox,
              Text(
                number!,
                style: const TextStyle(
                  color: kRed,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ), //Car number
              if (imgUrl != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imgUrl!), // Display the captured image
                ), //show img if any
              kListHeaders,
              SizedBox(
                height: 150.0,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 65.0),
                  children: fines.entries.map((entry) {
                    return ListTile(
                      leading: Text(
                        entry.key,
                        style: const TextStyle(
                            color: kBlack, fontSize: 15.0, wordSpacing: 0.01),
                      ), // Display the fine description
                      trailing: Text(
                        '₹${entry.value}',
                        style: const TextStyle(
                          color: kRed,
                          fontSize: 16.0,
                        ),
                      ), // Display the penalty amount
                    );
                  }).toList(), // Convert the iterable to a list
                ),
              ),
              RoundButton(
                onPressed: () {
                  // Add the fine details to the Firestore
                  _firestore.collection('fines').add({
                    'by': officerId,
                    'date': FieldValue.serverTimestamp(),
                    'fines': fines,
                    'total': total,
                    'photo': imgUrl,
                    'to': number,
                    'status': 'Pending',
                  });
                  int count = 0;
                  // Navigate back to the home screen
                  Navigator.popUntil(context, (route) => count++ == 2);
                },
                text: 'Confirm',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
