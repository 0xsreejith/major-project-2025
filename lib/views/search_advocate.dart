import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmyadvocate/views/advocate_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findmyadvocate/controller/auth_controller.dart';
import 'package:findmyadvocate/model/advocate_model.dart';

class SearchAdvocateScreen extends StatefulWidget {
  const SearchAdvocateScreen({super.key});

  @override
  _SearchAdvocateScreenState createState() => _SearchAdvocateScreenState();
}

class _SearchAdvocateScreenState extends State<SearchAdvocateScreen> {
  final AuthController _authController = Get.find<AuthController>();
  String searchQuery = "";
  String selectedSpecialty = "All";

  List<String> specialties = [
    "All",
    "Civil Law",
    "Criminal Law",
    "Corporate Law",
    "Family Law"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),

      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search advocates...",
                    prefixIcon: Icon(Icons.search, color: Colors.indigo),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
            ),

            // 📍 Specialty Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSpecialty,
                    onChanged: (value) {
                      setState(() {
                        selectedSpecialty = value!;
                      });
                    },
                    isExpanded: true,
                    items: specialties.map((specialty) {
                      return DropdownMenuItem(
                        value: specialty,
                        child: Text(specialty, style: TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // 📋 Advocate List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('advocates')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No Advocates Found"));
                  }

                  var advocates = snapshot.data!.docs
                      .map((doc) => AdvocateModel.fromMap(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ))
                      .toList();

                  // 🔍 Apply Search Filter
                  if (searchQuery.isNotEmpty) {
                    advocates = advocates
                        .where((advocate) =>
                            advocate.name.toLowerCase().contains(searchQuery) ||
                            advocate.specialty
                                .toLowerCase()
                                .contains(searchQuery))
                        .toList();
                  }

                  // 📍 Apply Specialty Filter
                  if (selectedSpecialty != "All") {
                    advocates = advocates
                        .where((advocate) =>
                            advocate.specialty == selectedSpecialty)
                        .toList();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    itemCount: advocates.length,
                    itemBuilder: (context, index) {
                      final advocate = advocates[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo[100],
                            backgroundImage: advocate.imageUrl.isNotEmpty
                                ? NetworkImage(advocate.imageUrl)
                                : null, // Show image if available
                            child: advocate.imageUrl.isEmpty
                                ? Icon(Icons.person,
                                    color: Colors
                                        .indigo) // Default icon if no image
                                : null,
                          ),
                          title: Text(advocate.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(advocate.specialty,
                              style: TextStyle(color: Colors.grey[700])),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.indigo),
                          onTap: () {
                            Get.to(
                                () => AdvocateDetailScreen(advocate: advocate));
                          },
                        ),
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
}
