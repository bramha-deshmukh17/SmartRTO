import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_rto/Utility/Constants.dart';
import 'package:smart_rto/Utility/RoundButton.dart';

import 'OfficerProfile.dart';


class Confirmfine extends StatefulWidget {
  static const String id = 'ConfirmFine';

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
        Map<String, dynamic> data = officerDoc.data() as Map<String, dynamic>;

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
    //getting fines data collected from previous screen
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
      appBar: AppBar(
        title: kAppBarTitle,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: kBackArrow),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Profile.id);
            },
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                Icons.person,
                color: kWhite,
              ),),
          ),
        ],
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
              ),//Car number
              if (imgUrl != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imgUrl!), // Display the captured image
                ),//show img if any
              kListHeaders,
              SizedBox(
                height: 300.0,
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
                  _firestore.collection('fines').add({'by': officerId, 'date':FieldValue.serverTimestamp(), 'fines':fines, 'total': total, 'photo':imgUrl, 'to':number, 'status': 'Pending',});
                  int count = 0;
                  Navigator.popUntil(context, (route) => count++ == 2);
                },
                text:'Confirm',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
