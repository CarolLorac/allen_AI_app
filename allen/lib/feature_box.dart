import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({
    super.key, 
    required this.color, 
    required this.headerText, 
    required this.descriptionText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(top:10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                headerText, 
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 3,),
          Text(
              descriptionText, 
              style: const TextStyle(
                fontFamily: 'Cera Pro',
            ),
          ),
        ],
      ),
    );
  }
}