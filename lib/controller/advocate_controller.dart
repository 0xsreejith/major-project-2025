  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import '../model/advocate_model.dart';

  class AdvocateController extends GetxController {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    RxList<AdvocateModel> advocatesList = <AdvocateModel>[].obs;
    RxBool isLoading = false.obs;
      var isLoadingTop = true.obs;
    @override
    void onInit() {
      fetchAdvocates();
      fetchTopAdvocates(5); 
      super.onInit();
    }


  void fetchTopAdvocates(int limit) async {
    try {
      isLoadingTop(true);
      var querySnapshot = await FirebaseFirestore.instance
          .collection('advocates')
          .orderBy('experience', descending: true) // Sorting by highest experience (example)
          .limit(limit) // Limiting to 5 advocates
          .get();

      advocatesList.value = querySnapshot.docs
          .map((doc) => AdvocateModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error fetching advocates: $e");
    } finally {
      isLoading(false);
    }
  }
    /// 🔹 Fetch All Advocates
  Future<void> fetchAdvocates() async {
    try {
      isLoading(true);
      final QuerySnapshot querySnapshot = await _firestore.collection('advocates').get();

      advocatesList.assignAll(
        querySnapshot.docs.map((doc) => AdvocateModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList(),
      );

      print("✅ Fetched ${advocatesList.length} advocates");
    } catch (e) {
      print("❌ Error fetching advocates: $e");
      Get.snackbar('Error', 'Failed to fetch advocates: $e', backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }


    /// 🔎 Search Advocates
    RxList<AdvocateModel> searchResults = <AdvocateModel>[].obs;

    void searchAdvocates(String query) {
      if (query.isEmpty) {
        searchResults.clear();
      } else {
        searchResults.assignAll(advocatesList.where((advocate) =>
            advocate.name.toLowerCase().contains(query.toLowerCase()) ||
            advocate.specialty.toLowerCase().contains(query.toLowerCase())));
      }
    }

    /// ✏ Update Advocate Info
    Future<void> updateAdvocate(String id, Map<String, dynamic> updatedData) async {
      try {
        await _firestore.collection('advocates').doc(id).update(updatedData);
        Get.snackbar('Success', 'Advocate updated successfully!', backgroundColor: Colors.green);
        fetchAdvocates(); // Refresh list
        Get.back(); // Close the edit screen
      } catch (e) {
        print("❌ Error updating advocate: $e");
        Get.snackbar('Error', 'Failed to update advocate: $e', backgroundColor: Colors.red);
      }
    }

    /// 🗑 Delete Advocate
    Future<void> deleteAdvocate(String id) async {
      try {
        await _firestore.collection('advocates').doc(id).delete();
        advocatesList.removeWhere((advocate) => advocate.id == id);
        Get.snackbar('Success', 'Advocate deleted successfully!', backgroundColor: Colors.green);
      } catch (e) {
        print("❌ Error deleting advocate: $e");
        Get.snackbar('Error', 'Failed to delete advocate: $e', backgroundColor: Colors.red);
      }
    }

    /// ➕ Create Advocate
    Future<void> createAdvocate({
      required String name,
      required String email,
      required String specialty,
      required String location,
      required String experience,
      required String description,
      required String enrollmentNumber,
      required String mobileNumber,
      required String practicePlace,
      required String qualifications,
      required String barCouncilNumber,
      required String imageUrl,
    }) async {
      try {
        DocumentReference docRef = _firestore.collection('advocates').doc();

        await docRef.set({
          'id': docRef.id,
          'name': name,
          'imageUrl': imageUrl,
          'email': email,
          'specialty': specialty,
          'location': location,
          'experience': experience,
          'description': description,
          'enrollmentNumber': enrollmentNumber,
          'mobileNumber': mobileNumber,
          'practicePlace': practicePlace,
          'qualifications': qualifications,
          'barCouncilNumber': barCouncilNumber,
          'createdAt': DateTime.now().toIso8601String(),
        });

        Get.snackbar('Success', 'Advocate added successfully!', backgroundColor: Colors.green);
        fetchAdvocates();
      } catch (e) {
        print("❌ Error adding advocate: $e");
        Get.snackbar('Error', 'Failed to add advocate: $e', backgroundColor: Colors.red);
      }
    }
  }
