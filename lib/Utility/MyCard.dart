import 'package:flutter/material.dart';
import 'Constants.dart';

class CustomCard extends StatelessWidget {
  final dynamic icon;
  final String cardTitle;
  final dynamic onTap;
  final dynamic big;

  const CustomCard(
      {super.key,
      this.icon,
      this.cardTitle = '',
      this.onTap,
      this.big = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: big ? 300 : 200,
      height: big ? 300 : 150,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: kSecondaryColor,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    cardTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
