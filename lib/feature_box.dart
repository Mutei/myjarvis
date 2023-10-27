import 'package:flutter/material.dart';
import 'pallete.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox(
      {Key? key,
      required this.colour,
      required this.title,
      required this.description})
      : super(key: key);
  final Color colour;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
