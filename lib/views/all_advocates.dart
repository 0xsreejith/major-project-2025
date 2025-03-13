import 'package:findmyadvocate/controller/advocate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllAdvocates extends StatelessWidget {
  final AdvocateController advocateController = Get.put(AdvocateController());

  AllAdvocates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Advocates List")),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (query) => advocateController.searchAdvocates(query),
              decoration: InputDecoration(
                hintText: "Search by name or specialty...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // 📌 Advocates List
          Expanded(
            child: Obx(() {
              if (advocateController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final list = advocateController.searchResults.isNotEmpty
                  ? advocateController.searchResults
                  : advocateController.advocatesList;

              if (list.isEmpty) {
                return Center(child: Text('No Advocates Found'));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final advocate = list[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: advocate.imageUrl.isNotEmpty
                            ? NetworkImage(advocate.imageUrl)
                            : AssetImage("assets/default-avatar.png") as ImageProvider,
                      ),
                      title: Text(advocate.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(advocate.specialty),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✏ Edit Button
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Get.toNamed('/edit-advocate', arguments: advocate);
                            },
                          ),

                          // 🗑 Delete Button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, advocate.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.toNamed('/advocate-details', arguments: advocate);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// ⚠ Confirm Advocate Deletion
  void _confirmDelete(BuildContext context, String advocateId) {
    Get.defaultDialog(
      title: "Delete Advocate",
      middleText: "Are you sure you want to delete this advocate?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        advocateController.deleteAdvocate(advocateId);
        Get.back(); // Close the dialog
      },
    );
  }
}
