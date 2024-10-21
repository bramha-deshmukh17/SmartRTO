import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomCard extends StatelessWidget {
  final dynamic icon;
  final String cardTitle;
  final String cardDescription;
  final dynamic button1;
  final dynamic button2;

  const CustomCard(
      {super.key,
      this.icon,
      this.cardTitle = '',
      this.cardDescription = '',
      this.button1,
      this.button2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 8, // Shadow intensity
        margin: EdgeInsets.all(8), // Margin around the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Align children to the start
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  cardTitle,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'InriaSans',),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 100.0,
                ),
              ),
            ),
            OverflowBar(
              children: <Widget>[
                button1,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
