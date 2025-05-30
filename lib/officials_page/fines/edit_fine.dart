import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/search_dropdown.dart';
import '../utility/fines_list.dart';

class EditFine extends StatefulWidget {
  static const String id = "officer/fine/edit";

  const EditFine({super.key});

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
    //fetch finesdata from firestore
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('finesdata').doc('penalties').get();
      finesAndPenalties = Map<String, int>.from(snapshot.data()!);
      return finesAndPenalties;
    } catch (e) {
      print('Error fetching fines: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchVehicleFinesFromFirestore() async {
    //fetch vehicle finesdata from firestore
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('fines').doc(args?['id']).get();
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
              child: CircularProgressIndicator(
              color: kSecondaryColor,
            )) // Show loading indicator
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
                  kBox,
                  // Display License Plate, Issued By, Issued on, Total Fine, Status
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

                  // Display Fines and its edit option
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      kListHeaders,
                      FineList(
                        selectedFines: fineData['fines'],
                      ), //selected fines list
                    ]),
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
                  0.6, // Limits bottom sheet to 60% of the screen height
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
                                  //button to remove fines
                                  icon: Icon(FontAwesomeIcons.trash,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      selectedFines.remove(entry.key);
                                      // Calculate the total fine amount by summing all values in the selectedFines map
                                      total = selectedFines.values
                                          // Use the fold method to iterate over each fine amount
                                          .fold(0, (sum, value) => sum + value);
                                      // The fold method starts with an initial sum of 0
                                      // For each fine amount (value), add it to the current sum
                                      // The result is the total sum of all fine amounts
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
                          'status': total == 0 ? 'Paid' : fineData['status'],
                        }).then((_) {
                          print("Fine data updated successfully");
                        }).catchError((error) {
                          print("Error updating fine data: $error");
                        });

                        //  Refresh fineData in EditFine class
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
