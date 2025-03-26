import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';

class ModifyFineData extends StatefulWidget {
  static const String id = "officer/fine/modify";

  const ModifyFineData({super.key});

  @override
  _ModifyFineDataState createState() => _ModifyFineDataState();
}

class _ModifyFineDataState extends State<ModifyFineData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _editFine = TextEditingController();
  final TextEditingController _newFineName = TextEditingController();
  final TextEditingController _newFineAmt = TextEditingController();
  Map<String, num> finesData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFinesData();
  }

  Future<void> fetchFinesData() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('finesdata').doc('penalties').get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          finesData = Map<String, num>.from(data);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching finesData: $e");
    }
  }

  void addFine(String key, num value) {
    setState(() {
      finesData[key] = value;
    });
    _firestore.collection('finesdata').doc('penalties').set(finesData);
  }

  void modifyFine(String key, num value) {
    if (finesData.containsKey(key)) {
      setState(() {
        finesData[key] = value;
      });
      _firestore.collection('finesdata').doc('penalties').set(finesData);
    }
  }

  void deleteFine(String key) {
    if (finesData.containsKey(key)) {
      setState(() {
        finesData.remove(key);
      });
      _firestore.collection('finesdata').doc('penalties').set(finesData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: RoundButton(
          onPressed: () {
            _showAddBottomSheet(context, _newFineName, _newFineAmt);
          },
          text: 'Add New'),
      appBar: Appbar(
        title: 'Modify Fines Data',
        displayOfficerProfile: true,
        isBackButton: true,
      ),
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(
                color: kSecondaryColor,
              ),
          )
          : finesData.isEmpty
              ? Center(child: Text('No fines data available'))
              : ListView.builder(
                  itemCount: finesData.length,
                  itemBuilder: (context, index) {
                    String key = finesData.keys.elementAt(index);
                    return ListTile(
                      title: Text('$key: ${finesData[key]}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditBottomSheet(
                                  context, _editFine, key, finesData[key]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteFine(key);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _showEditBottomSheet(BuildContext context,
      TextEditingController controller, String title, num? value) {
    controller.text = value.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Better UX
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Modify Fines",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 16.0, color: kBlack),
                      ),
                      UserInput(
                        controller: controller,
                        hint: 'Fine Amount',
                        keyboardType: TextInputType.number,
                        width: double.infinity,
                      ),
                      RoundButton(
                        onPressed: () {
                          Navigator.pop(context);
                          modifyFine(title, num.parse(controller.text));
                        },
                        text: "Modify",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(
      BuildContext context,
      TextEditingController controllerName,
      TextEditingController controllerAmt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Better UX
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Fines",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      UserInput(
                        controller: controllerName,
                        hint: 'Fine Title',
                        keyboardType: TextInputType.text,
                        width: double.infinity,
                      ),
                      UserInput(
                        controller: controllerAmt,
                        hint: 'Fine Amount',
                        keyboardType: TextInputType.number,
                        width: double.infinity,
                      ),
                      RoundButton(
                        onPressed: () {
                          Navigator.pop(context);
                          addFine(controllerName.text,
                              num.parse(controllerAmt.text));
                          controllerName.text = '';
                          controllerAmt.text = '';
                        },
                        text: "Add",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
