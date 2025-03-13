import 'package:findmyadvocate/views/legal_advice_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting dates
import '../controller/legal_advice_controller.dart';
import '../model/legal_advice_model.dart';

class LegalAdviceListScreen extends StatelessWidget {
  final LegalAdviceController legalAdviceController = Get.put(LegalAdviceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Legal Advice")),
      body: Obx(
        () => legalAdviceController.legalAdviceList.isEmpty
            ? Center(child: Text("No legal advice available", style: TextStyle(fontSize: 18, color: Colors.grey)))
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: legalAdviceController.legalAdviceList.length,
                itemBuilder: (context, index) {
                  final advice = legalAdviceController.legalAdviceList[index];
                  return _buildAdviceCard(advice);
                },
              ),
      ),
    );
  }

  /// Widget to create a stylish legal advice card
  Widget _buildAdviceCard(LegalAdviceModel advice) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        title: Text(
          advice.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            _buildCategoryBadge(advice.category), // Category badge
            SizedBox(height: 4),
            Text(
              "Added on: ${_formatDate(advice.createdAt)}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
        onTap: () => Get.to(() => LegalAdviceDetailScreen(advice: advice)),
      ),
    );
  }

  /// Format date from DateTime object
  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown Date";
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Widget for Category Badge
  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
