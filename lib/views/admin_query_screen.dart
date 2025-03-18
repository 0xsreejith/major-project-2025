import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_query_detail_screen.dart'; // Import the detail screen

class AdminUserQueriesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Queries")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('legal_queries').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No user queries yet."));
          }

          var queries = snapshot.data!.docs;
          return ListView.builder(
            itemCount: queries.length,
            itemBuilder: (context, index) {
              var query = queries[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(query['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Email: ${query['email']}"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.to(() => AdminQueryDetailScreen(query: query));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
