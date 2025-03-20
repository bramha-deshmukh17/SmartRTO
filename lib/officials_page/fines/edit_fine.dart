import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utility/appbar.dart';
import '../../utility/round_button.dart';
import '../../utility/search_dropdown.dart';

class EditFine extends StatefulWidget {
  static const String id = "officer/fine/edit";

  @override
  _EditFineState createState() => _EditFineState();
}

class _EditFineState extends State<EditFine> {
  late Map<String, dynamic> fineData = {};
  late Map<String, int> finesAndPenalties = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _dropdownSearchFieldController =
      TextEditingController();
  final SuggestionsBoxController _suggestionBoxController =
      SuggestionsBoxController();
  Map<String, dynamic>? args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    fetchFines();

    print('id: ${args?['id']}');
    
    print('fineData: $fineData');
  }

  void fetchFines() async {
    Map<String, int> fines = await fetchFinesFromFirestore();
    Map<String, dynamic> fines2 = await fetchVehicleFinesFromFirestore();
    setState(() {
      finesAndPenalties = fines;
      fineData = fines2;
      fineData['id'] = args?['id']; 
    });
  }

  Future<Map<String, int>> fetchFinesFromFirestore() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('finesdata')
          .doc('penalties')
          .get();
      finesAndPenalties = Map<String, int>.from(snapshot.data()!);
      return finesAndPenalties;
    } catch (e) {
      print('Error fetching fines: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchVehicleFinesFromFirestore() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('fines')
          .doc(args?['id'])
          .get();
      return snapshot.data() ?? {};
    } catch (e) {
      print('Error fetching fines: $e');
      return {};
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Edit Fine',
        isBackButton: true,
        displayOfficerProfile: true,
      ),
      body: fineData.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fineData.containsKey('photo') &&
                      fineData['photo'] != null)
                    Image.network(
                      fineData['photo'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 100),
                    ),
                  const SizedBox(height: 16),

                  Text(
                    'License Plate: ${fineData['to'] ?? "N/A"}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Issued By: ${fineData['by'] ?? "N/A"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Issued on: ${fineData.containsKey('date') && fineData['date'] != null ? _formatDate((fineData['date'] as Timestamp).toDate()) : "Unknown"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Total Fine: ₹${fineData['total'] ?? 0}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Status: ${fineData['status'] ?? "Unknown"}',
                    style: TextStyle(
                      fontSize: 18,
                      color: (fineData['status'] == 'Pending')
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (fineData['transaction_id'] != null)
                    Text(
                      'Transaction ID: ${fineData["transaction_id"]}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 16),

                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Fines:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (fineData['status'] == 'Pending')
                        IconButton(
                          icon: Icon(FontAwesomeIcons.edit),
                          onPressed: () => _showBottomSheet(context),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (fineData.containsKey('fines') &&
                      fineData['fines'] != null)
                    Column(
                      children: fineData['fines'].entries.map<Widget>((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Text(
                            '₹${entry.value}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  void _showBottomSheet(BuildContext context) {
    Map<String, int> selectedFines =
        Map<String, int>.from(fineData['fines'] ?? {});
    int total = fineData['total'] ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Keep this for a better UX
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FractionallySizedBox(
              heightFactor:
                  0.6, // ✅ Limits bottom sheet to 60% of the screen height
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Modify Fines",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Search Dropdown to Add Fines
                    SearchDropDown(
                      dropdownSearchFieldController:
                          _dropdownSearchFieldController,
                      suggestionBoxController: _suggestionBoxController,
                      finesAndPenalties: finesAndPenalties,
                      onSelectedFine: (String fine, int amount) {
                        setState(() {
                          selectedFines[fine] = amount;
                        });
                      },
                      onTotalChanged: (int amount) {
                        setState(() {
                          total += amount;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    // List of Selected Fines with Fixed Height
                    SizedBox(
                      height: 200,
                      child: ListView(
                        shrinkWrap: true,
                        children: selectedFines.entries.map<Widget>((entry) {
                          return ListTile(
                            title: Text(entry.key),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${entry.value}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      selectedFines.remove(entry.key);
                                      total = selectedFines.values
                                          .fold(0, (sum, value) => sum + value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Display Updated Total Fine
                    Text(
                      'Total Fine: ₹$total',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    // Update Button
                    RoundButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _firestore
                            .collection('fines')
                            .doc(fineData['id'])
                            .update({
                          'fines': selectedFines,
                          'total': total,
                        }).then((_) {
                          print("Fine data updated successfully");
                        }).catchError((error) {
                          print("Error updating fine data: $error");
                        });

                        // ✅ Refresh fineData in EditFine class
                        setState(() {
                          fineData['fines'] = selectedFines;
                          fineData['total'] = total;
                        });
                      },
                      text: "Update",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
