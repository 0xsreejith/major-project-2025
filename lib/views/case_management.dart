import 'package:findmyadvocate/controller/case_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CaseManagementScreen extends StatelessWidget {
  final CaseController caseController = Get.put(CaseController());

  final TextEditingController caseNumberController = TextEditingController();
  final TextEditingController caseTitleController = TextEditingController();
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController hearingDateController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  String selectedStatus = "Pending";

  CaseManagementScreen({super.key}); // Default case status

  void _showAddCaseDialog(BuildContext context, {String? caseId}) {
    if (caseId == null) {
      caseNumberController.clear();
      caseTitleController.clear();
      courtNameController.clear();
      hearingDateController.clear();
      detailsController.clear();
      selectedStatus = "Pending";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(caseId == null ? "Add Case" : "Edit Case"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: caseNumberController,
                  decoration: InputDecoration(labelText: "Case Number"),
                ),
                TextField(
                  controller: caseTitleController,
                  decoration: InputDecoration(labelText: "Case Title"),
                ),
                TextField(
                  controller: courtNameController,
                  decoration: InputDecoration(labelText: "Court Name"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  onChanged: (newValue) {
                    selectedStatus = newValue!;
                  },
                  items: ["Pending", "Hearing Scheduled", "Under Investigation", "Judgment Reserved", "Closed", "Appealed", "Dismissed"]
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  decoration: InputDecoration(labelText: "Case Status"),
                ),
                TextField(
                  controller: hearingDateController,
                  decoration: InputDecoration(labelText: "Hearing Date"),
                ),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: "Details"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                var caseData = {
                  'caseNumber': caseNumberController.text,
                  'caseTitle': caseTitleController.text,
                  'courtName': courtNameController.text,
                  'status': selectedStatus,
                  'hearingDate': hearingDateController.text,
                  'details': detailsController.text,
                  'createdAt': DateTime.now().toIso8601String(),
                };

                if (caseId == null) {
                  caseController.addCase(caseData);
                } else {
                  caseController.updateCase(caseId, caseData);
                }

                Get.back();
              },
              child: Text(caseId == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    caseController.fetchCases(); // Fetch cases when screen loads

    return Scaffold(
      appBar: AppBar(title: Text("Case Management")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCaseDialog(context),
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (caseController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: caseController.casesList.length,
          itemBuilder: (context, index) {
            var caseData = caseController.casesList[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(caseData.caseTitle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Case No: ${caseData.caseNumber}"),
                    Text("Status: ${caseData.status}"),
                    Text("Court: ${caseData.courtName}"),
                    Text("Hearing Date: ${caseData.hearingDate}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showAddCaseDialog(context, caseId: caseData.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => caseController.deleteCase(caseData.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
