import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utility/constants.dart';
import 'formdata.dart';

class SlotBooking extends StatefulWidget {
  final FormData formData;

  SlotBooking({required this.formData});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String? selectedSlotId; // Track selected slot

  Future<List<Map<String, dynamic>>> fetchSlots() async {
    final now = DateTime.now();
    final todayStart =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final querySnapshot = await _fireStore
        .collection('slots')
        .where('date', isGreaterThanOrEqualTo: todayStart)
        .orderBy('date', descending: false)
        .get();

    return querySnapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();
  }

  void _bookSlot(int slotNo, String slotId) {
    setState(() {
      widget.formData.slot_no = slotNo == 1 ? 'slot1' : 'slot2';
      widget.formData.slot_id = slotId;
      selectedSlotId =
          slotId + (slotNo == 1 ? '_1' : '_2'); // Unique identifier
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
              if (widget.formData.fieldErrors['slot'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.formData.fieldErrors['slot']!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
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
                                        (slot['date'] as Timestamp).toDate()),
                                    style: TextStyle(
                                        fontSize: 18.0, color: kGreen),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: slot['slot1']['remaining'] > 0
                                      ? () => _bookSlot(1, slot['id'])
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedSlotId ==
                                            '${slot['id']}_1'
                                        ? kSecondaryColor // Highlighted color
                                        : kWhite, // Default color
                                  ),
                                  child: ListTile(
                                    title: Text('Slot 1: Morning 10AM'),
                                    subtitle: Text(
                                      '${slot['slot1']['remaining']} remaining',
                                      style: TextStyle(
                                        color: slot['slot1']['remaining'] > 0
                                            ? kGreen
                                            : kRed,
                                      ),
                                    ),
                                  ),
                                ),
                                kBox,
                                ElevatedButton(
                                  onPressed: slot['slot2']['remaining'] > 0
                                      ? () => _bookSlot(2, slot['id'])
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedSlotId ==
                                            '${slot['id']}_2'
                                        ? kSecondaryColor // Highlighted color
                                        : kWhite, // Default color
                                  ),
                                  child: ListTile(
                                    title: Text('Slot 2: Afternoon 2PM'),
                                    subtitle: Text(
                                      '${slot['slot2']['remaining']} remaining',
                                      style: TextStyle(
                                        color: slot['slot2']['remaining'] > 0
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
    );
  }
}
