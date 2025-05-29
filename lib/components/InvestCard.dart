// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/InfoColumn.dart';

class InvestCard extends StatelessWidget {
  final String title;
  final String invMin;
  final String resgate;
  final String ir;

  const InvestCard({
    super.key,
    required this.title,
    required this.invMin,
    required this.resgate,
    required this.ir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoColumn(
                    label: 'Inv. Mínimo', value: invMin, color: Colors.pink),
                InfoColumn(
                    label: 'Resgate', value: resgate, color: Colors.green),
                InfoColumn(label: 'IR', value: ir, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
