import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_rto/OfficialsPage/HomeScreen.dart';
import 'package:smart_rto/Utility/Constants.dart';
import 'package:smart_rto/Utility/RoundButton.dart';


class Confirmfine extends StatefulWidget {
  static const String id = 'ConfirmFine';

  const Confirmfine({super.key});

  @override
  State<Confirmfine> createState() => _ConfirmfineState();
}

class _ConfirmfineState extends State<Confirmfine> {
  late Map<String, int> fines;
  late int total;
  String? number, imgUrl;
  final FirebaseFirestore _auth = FirebaseFirestore.instance;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    fines = arguments['fines'];
    total = arguments['total'];
    number = arguments['number'];
    imgUrl = arguments['imgUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: kAppBarTitle,
          backgroundColor: kPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: kBackArrow),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              number!,
              style: const TextStyle(
                color: kRed,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (imgUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imgUrl!), // Display the captured image
              ),
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
                _auth.collection('fines').add({'by': 'test@email.com', 'date':FieldValue.serverTimestamp(), 'fines':fines, 'photo':imgUrl, 'to':number,});
                int count = 0;
                Navigator.popUntil(context, (route) => count++ == 2);
              },
              text:'Confirm',
              ),
          ],
        ),
      ),
    );
  }
}
