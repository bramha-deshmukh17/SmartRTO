import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import 'payment_page.dart';

class VehicleDetails extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final String number; // License plate

  const VehicleDetails(
      {super.key, required this.vehicle, required this.number});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<QuerySnapshot<Map<String, dynamic>>> _finesData;

  @override
  void initState() {
    super.initState();
    _finesData = _fetchFinesData(widget.number);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchFinesData(
      String licensePlate) async {
    return await _firestore
        .collection('fines')
        .where('to', isEqualTo: licensePlate)
        .orderBy('date', descending: true)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Vehicle Details',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Model: ${widget.vehicle['model'] ?? 'Unknown Model'}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kBox,
                Row(
                  children: [
                    const Text(
                      'Type: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    _getIcon(widget.vehicle['type']),
                  ],
                ),
                kBox,
                Text(
                  'License Plate: ${widget.number}',
                  style: const TextStyle(fontSize: 18),
                ),
                kBox,
                _buildInsuranceDetails(),
                kBox,
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: _finesData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: kSecondaryColor,));
                    }
                    if (snapshot.hasError) {
                      return const Text('Error fetching fines data.');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No fines found for this vehicle.');
                    }
                    final fines = snapshot.data!.docs;
                    return _buildFinesList(fines);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceDetails() {
    //to display vehicle details
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insurance Company: ${widget.vehicle['insurance_company'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 18),
        ),
        kBox,
        Text(
          'Insurance No.: ${widget.vehicle['insurance_no'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 18),
        ),
        kBox,
        Text(
          'Insurance Expiry: ${_formatDate(widget.vehicle['insurance_expiry'].toDate())}',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildFinesList(
    //to display the list of fine
      List<QueryDocumentSnapshot<Map<String, dynamic>>> fines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fines:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        kBox,
        ...fines.map((fine) {
          final fineData = fine.data();  // This is the Map<String, dynamic> data
          final fineId = fine.id;  // This is the document ID

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: ListTile(
                leading: fineData['photo'] != null
                    ? Image.network(
                  fineData['photo'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.image_not_supported),
                title: Text('Total Fine: ₹${fineData['total']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...fineData['fines'].entries.map((entry) => Text(
                      '${entry.key}: ₹${entry.value}',
                      style: const TextStyle(fontSize: 16),
                    )),
                    Text(
                      'Status: ${fineData['status']}',
                      style: TextStyle(
                        color: fineData['status'] == 'Pending'
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                    Text('Issued on: ${_formatDate(fineData['date'].toDate())}'),
                    Text('By: ${fineData['by']}'),
                  ],
                ),
                onTap: () {
                  // Pass the fineId to the PaymentPage constructor
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(fineid: fineId),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }


  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Widget _getIcon(String type) {
    //get icons for the vehicle type
    switch (type) {
      case 'TW':
        return const Icon(FontAwesomeIcons.motorcycle);
      case 'FW':
        return const Icon(FontAwesomeIcons.car);
      case 'bus':
        return const Icon(FontAwesomeIcons.bus);
      case 'truck':
        return const Icon(FontAwesomeIcons.truck);
      default:
        return const Icon(FontAwesomeIcons.ban);
    }
  }
}
