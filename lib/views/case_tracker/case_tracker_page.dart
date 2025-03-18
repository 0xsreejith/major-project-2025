import 'package:findmyadvocate/controller/case_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CaseManagementPage extends StatelessWidget {
  final CaseController caseController = Get.put(CaseController());

   CaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    caseController.fetchCases(); // Fetch cases when page loads

    return Scaffold(
      appBar: AppBar(title: Text("Case Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ➕ Add Case Button
            ElevatedButton(
              onPressed: () => _showAddCaseDialog(context),
              child: Text("Add Case"),
            ),
            SizedBox(height: 20),

            // 📌 Cases List
            Expanded(
              child: Obx(() {
                if (caseController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (caseController.casesList.isEmpty) {
                  return Center(child: Text("No cases available"));
                }
                return ListView.builder(
                  itemCount: caseController.casesList.length,
                  itemBuilder: (context, index) {
                    var caseData = caseController.casesList[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(caseData.caseTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Court: ${caseData.courtName}"),
                            Text("Status: ${caseData.status}"),
                            Text("Next Hearing: ${caseData.hearingDate}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, caseData.caseNumber);
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Show Add Case Dialog
  void _showAddCaseDialog(BuildContext context) {
    final TextEditingController caseTitleController = TextEditingController();
    final TextEditingController courtNameController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();
    final RxString selectedDate = "".obs; // Observing the date

    Get.defaultDialog(
      title: "Add Case",
      content: Column(
        children: [
          _buildTextField("Case Title", caseTitleController),
          _buildTextField("Court Name", courtNameController),
          _buildTextField("Status", statusController),
          _buildTextField("Details", detailsController),

          // 📅 Date Picker Field
          Obx(() => TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Next Hearing Date",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        selectedDate.value = DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                ),
                controller: TextEditingController(text: selectedDate.value),
              )),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (caseTitleController.text.isNotEmpty) {
            caseController.addCase({
              "caseTitle": caseTitleController.text,
              "courtName": courtNameController.text,
              "status": statusController.text,
              "hearingDate": selectedDate.value, // Save selected date
              "details": detailsController.text,
            });
            Get.back();
          }
        },
        child: Text("Save"),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
    );
  }

  // 🔹 Confirm Delete Case
  void _confirmDelete(BuildContext context, String caseId) {
    Get.defaultDialog(
      title: "Delete Case",
      middleText: "Are you sure you want to delete this case?",
      confirm: ElevatedButton(
        onPressed: () {
          caseController.deleteCase(caseId);
          Get.back();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: Text("Delete"),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
    );
  }

  // 🔹 Text Field Helper
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
