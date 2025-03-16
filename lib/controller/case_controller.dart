import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmyadvocate/model/case_model.dart';
import 'package:get/get.dart';

class CaseController extends GetxController {
  var casesList = <CaseModel>[].obs;
  var caseDetails = Rxn<CaseModel>(); // Holds the searched case
  var isLoading = false.obs;

  // 🔹 Fetch all cases from Firestore
  void fetchCases() async {
    isLoading.value = true;
    try {
      var snapshot = await FirebaseFirestore.instance.collection('cases').get();
      casesList.value = snapshot.docs
          .map((doc) => CaseModel.fromJson(doc.id, doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch cases");
    }
    isLoading.value = false;
  }

  // 🔍 Search case by case number
  Future<void> searchCase(String caseNumber) async {
    isLoading.value = true;
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('cases')
          .where('caseNumber', isEqualTo: caseNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        caseDetails.value = CaseModel.fromJson(doc.id, doc.data());
      } else {
        caseDetails.value = null; // No case found
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to search case");
      caseDetails.value = null;
    }
    isLoading.value = false;
  }

  // ➕ Add case to Firestore
  Future<void> addCase(Map<String, dynamic> caseData) async {
    try {
      await FirebaseFirestore.instance.collection('cases').add(caseData);
      fetchCases(); // Refresh list
      Get.snackbar("Success", "Case added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add case");
    }
  }

  // ✏️ Update case in Firestore
  Future<void> updateCase(String caseId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('cases').doc(caseId).update(updatedData);
      fetchCases(); // Refresh list
      Get.snackbar("Success", "Case updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update case");
    }
  }

  // ❌ Delete case from Firestore
  Future<void> deleteCase(String caseId) async {
    try {
      await FirebaseFirestore.instance.collection('cases').doc(caseId).delete();
      fetchCases(); // Refresh list
      Get.snackbar("Success", "Case deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete case");
    }
  }
}
