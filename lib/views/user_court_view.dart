import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCourtDatesView extends StatelessWidget {
  const UserCourtDatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Court Dates")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📅 Upcoming Court Dates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('court_hirings')
                    .orderBy('date', descending: false) // Sort by date
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No court dates available"));
                  }
                  
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var hiring = snapshot.data!.docs[index];
                      var date = (hiring['date'] as Timestamp).toDate();
                      return _buildCourtDateCard(
                        lawyer: hiring['lawyer_name'],
                        caseDetails: hiring['case_details'],
                        time: hiring['time'],
                        date: date,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Court Date Card UI
  Widget _buildCourtDateCard({
    required String lawyer,
    required String caseDetails,
    required String time,
    required DateTime date,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.blue),
        title: Text("Adv. $lawyer", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📌 Case: $caseDetails", style: TextStyle(fontSize: 14)),
            Text("🕒 Time: $time", style: TextStyle(fontSize: 14)),
            Text("📅 Date: ${date.toLocal().toString().split(' ')[0]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
