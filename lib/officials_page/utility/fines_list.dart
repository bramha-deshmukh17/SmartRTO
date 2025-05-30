import 'package:flutter/material.dart';

import '../../utility/constants.dart';

class FineList extends StatelessWidget {
  final Map<String, dynamic> selectedFines;

  const FineList({super.key, required this.selectedFines});
  //display list of the fnes
  @override
  Widget build(BuildContext context) {
    return  ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 280.0, maxHeight: 150.0),
      child: ListView(
        children: selectedFines.entries.map((entry) {
          return ListTile(
            leading: Text(
              entry.key.length > 25
                ? '${entry.key.substring(0, 25)}...'
                : entry.key,
              style: const TextStyle(
              color: kBlack,
              fontSize: 15.0,
              wordSpacing: 0.01,
              fontFamily: 'InriaSans',
              ),
            ),
            trailing: Text(
              '₹${entry.value}',
              style: const TextStyle(
                color: kRed,
                fontSize: 16.0,
                fontFamily: 'InriaSans',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
