import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controller/court_hiring_controller.dart';

class AddCourtHiringView extends StatefulWidget {
  final String? hiringId;
  final Map<String, dynamic>? existingData;

  const AddCourtHiringView({super.key, this.hiringId, this.existingData});

  @override
  _AddCourtHiringViewState createState() => _AddCourtHiringViewState();
}

class _AddCourtHiringViewState extends State<AddCourtHiringView> {
  final CourtHiringController courtHiringController = Get.find();

  final TextEditingController lawyerController = TextEditingController();
  final TextEditingController caseDetailsController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      lawyerController.text = widget.existingData!['lawyer_name'];
      caseDetailsController.text = widget.existingData!['case_details'];
      timeController.text = widget.existingData!['time'];
      selectedDate = (widget.existingData!['date'] as Timestamp).toDate();
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  void saveHiring() async {
    if (lawyerController.text.isEmpty ||
        caseDetailsController.text.isEmpty ||
        timeController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Map<String, dynamic> hiringData = {
      'lawyer_name': lawyerController.text,
      'case_details': caseDetailsController.text,
      'time': timeController.text,
      'date': Timestamp.fromDate(selectedDate),
      'created_by': "admin",
    };

    if (widget.hiringId == null) {
      await FirebaseFirestore.instance.collection('court_hirings').add(hiringData);
    } else {
      await courtHiringController.updateCourtHiring(widget.hiringId!, hiringData);
    }

    Get.back();
  }

  void deleteHiring(String id) async {
    await courtHiringController.deleteCourtHiring(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Court Hirings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: lawyerController,
              decoration: InputDecoration(labelText: "Lawyer Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: caseDetailsController,
              decoration: InputDecoration(labelText: "Case Details", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Time (HH:MM AM/PM)",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: _pickTime,
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Select Date: ${DateFormat.yMMMd().format(selectedDate)}"),
              trailing: Icon(Icons.calendar_today, color: Colors.blue),
              onTap: _pickDate,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A237E),
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: saveHiring,
              child: Text(widget.hiringId == null ? "Add Hiring" : "Update Hiring"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: courtHiringController.courtHirings.length,
                    itemBuilder: (context, index) {
                      var hiring = courtHiringController.courtHirings[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(hiring['lawyer_name']),
                          subtitle: Text("Date: ${DateFormat.yMMMd().format((hiring['date'] as Timestamp).toDate())}\nTime: ${hiring['time']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteHiring(hiring['id']),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
