import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminQueryDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot query;

  AdminQueryDetailScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Query Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(query['name'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            
            Text("Email:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(query['email'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            
            Text("Query:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(query['message'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            
            Text("Submitted On:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(query['timestamp'] != null ? query['timestamp'].toDate().toString() : "N/A",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
