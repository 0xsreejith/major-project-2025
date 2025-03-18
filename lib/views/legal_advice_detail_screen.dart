import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/legal_advice_controller.dart';
import '../model/legal_advice_model.dart';

class LegalAdviceDetailScreen extends StatelessWidget {
  final LegalAdviceModel advice;

  const LegalAdviceDetailScreen({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(advice.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${advice.category}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Question:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(advice.question, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Answer:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(advice.answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
