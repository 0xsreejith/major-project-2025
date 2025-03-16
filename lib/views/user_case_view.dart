import 'package:findmyadvocate/controller/case_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CaseTrackerPage extends StatelessWidget {
  final CaseController caseController = Get.put(CaseController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Case Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Enter Case Number",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String caseNumber = searchController.text.trim();
                    if (caseNumber.isNotEmpty) {
                      caseController.searchCase(caseNumber);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // 📌 Display Case Details
            Obx(() {
              if (caseController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (caseController.caseDetails.value == null) {
                return Text("No case found", style: TextStyle(fontSize: 16));
              } else {
                var caseData = caseController.caseDetails.value!;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Case: ${caseData.caseTitle}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        Text("📍 Court: ${caseData.courtName}", style: TextStyle(fontSize: 16)),
                        Text("📌 Status: ${caseData.status}", style: TextStyle(fontSize: 16)),
                        Text("📅 Next Hearing: ${caseData.hearingDate}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text("📖 Details:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(caseData.details, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
