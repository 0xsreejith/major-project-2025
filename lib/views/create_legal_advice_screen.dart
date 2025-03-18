import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/legal_advice_controller.dart';

class CreateLegalAdviceScreen extends StatelessWidget {
  final LegalAdviceController legalAdviceController = Get.put(LegalAdviceController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  CreateLegalAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Legal Advice")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(titleController, "Title"),
            _buildTextField(categoryController, "Category (e.g. GST, Family Law)"),
            _buildTextField(questionController, "Question"),
            _buildTextField(answerController, "Answer", maxLines: 5),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                legalAdviceController.addLegalAdvice(
                  titleController.text.trim(),
                  categoryController.text.trim(),
                  questionController.text.trim(),
                  answerController.text.trim(),
                );
                Get.back();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}