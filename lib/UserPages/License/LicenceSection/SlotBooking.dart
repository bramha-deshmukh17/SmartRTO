import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Utility/Constants.dart';
import 'FormData.dart';

class SlotBooking extends StatefulWidget {
  final FormData formData;

  SlotBooking({required this.formData});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> slots = [];

  @override
  void initState() {
    super.initState();
    getSlotData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: slots.isEmpty
          ? CircularProgressIndicator()
          : ListView.builder(
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
                            (slot['date'] as Timestamp).toDate().toString(),
                            style: TextStyle(fontSize: 18.0, color: kGreen),),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: ListTile(
                          title: Text('Slot 1: Morning'),
                          subtitle:
                              Text('${slot['slot1']['remaining']} remaining'),
                        ),
                      ),
                      kBox,
                      ElevatedButton(
                        onPressed: () {},
                        child: ListTile(
                          title: Text('Slot 2: Afternoon'),
                          subtitle:
                              Text('${slot['slot2']['remaining']} remaining'),
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),
    );
  }

  void getSlotData() async {
    final now = Timestamp.now();
    final querySnapshot = await _fireStore
        .collection('slots')
        .where('date', isGreaterThan: now)
        .get();
    setState(() {
      slots = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
