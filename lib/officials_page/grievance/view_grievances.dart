import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';

class OfficerGrievanceList extends StatefulWidget {
  static const String id = "officer/grievancelist";
  const OfficerGrievanceList({super.key});

  @override
  State<OfficerGrievanceList> createState() => _OfficerGrievanceListState();
}

class _OfficerGrievanceListState extends State<OfficerGrievanceList> {

  final TextEditingController _replyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? replyError;
  List<Map<String, dynamic>>? grievanceList;

  Stream<QuerySnapshot> getGrievance(){
    return _firestore.collection('grievance').where('reply', isEqualTo: 'NA').snapshots();
  }

  void _showBottomSheet(BuildContext context, String docId) {
    print(docId);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            children: [
              kBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    docId,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy,),
                    onPressed: () {
                      // Copy label text to clipboard
                      Navigator.pop(context);
                      Clipboard.setData(ClipboardData(text: docId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    },
                  ),
                ],
              ),
              kBox,
              UserInput(
                controller: _replyController,
                errorText: replyError,
                hint: "Relpy*",
                keyboardType: TextInputType.text,
                submit: (_) {
                  // Move focus to the second TextField
                  FocusScope.of(context).unfocus();
                },
              ),
              kBox,
              RoundButton(
                  onPressed: () {
                    if(_replyController.text.isNotEmpty){
                      _firestore.collection('grievance').doc(docId).update({
                        'reply': _replyController.text,
                      });
                      Navigator.pop(context);
                    }else{
                      setState(() {
                        replyError = 'This is required field';
                      });
                    }
                  },
                  text: "Submit")
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
          title: 'Grievances',
          isBackButton: true,
          displayOfficerProfile: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: getGrievance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading Grievances.'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No New Grievances found.'));
            }

            // Display the list of vehicles
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var grievances = doc.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(grievances['fineno']),
                    subtitle: Text('Grievance: ${grievances['grievance']}'),
                    onTap: () {
                      // Navigate to the Grievances details screen
                      _showBottomSheet(context, doc.id);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
