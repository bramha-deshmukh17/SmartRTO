import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SearchDropDown extends StatefulWidget {
  final dynamic dropdownSearchFieldController;
  final dynamic suggestionBoxController;
  final Map<String, int> finesAndPenalties;
  final Function(String, int) onSelectedFine;
  final Function(int) onTotalChanged;

  SearchDropDown(
      {super.key,
        required this.dropdownSearchFieldController,
        required this.suggestionBoxController,
        required this.finesAndPenalties,
        required this.onSelectedFine,
        required this.onTotalChanged,
      });

  @override
  State<SearchDropDown> createState() => _SearchDropDownState();
}

class _SearchDropDownState extends State<SearchDropDown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      height: 60.0,
      child: DropDownSearchFormField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: kDropdown("Fine"),
          controller: widget.dropdownSearchFieldController,
        ),
        suggestionsCallback: (pattern) {
          return getSuggestions(pattern);
        },
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        itemSeparatorBuilder: (context, index) {
          return const Divider();
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (String suggestion) {
          widget.dropdownSearchFieldController.text = suggestion;
          addFines(suggestion);
        },
        suggestionsBoxController: widget.suggestionBoxController,
        displayAllSuggestionWhenTap: true,
      ),
    );
  }

  void addFines(String suggestion) {
    int fineAmount = widget.finesAndPenalties[suggestion]!;
    widget.onSelectedFine(suggestion, fineAmount); // Notify parent about the fine selected
    widget.onTotalChanged(fineAmount); // Notify parent about the total change
    widget.dropdownSearchFieldController.clear();
    setState(() {});
  }

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(widget.finesAndPenalties.keys);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
