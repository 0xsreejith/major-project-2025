import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/legal_advice_model.dart';

class LegalAdviceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<LegalAdviceModel> legalAdviceList = <LegalAdviceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLegalAdvices();
  }

  // Fetch all legal advices from Firestore
  Future<void> fetchLegalAdvices() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('legal_advices')
          .orderBy('createdAt', descending: true)
          .get();

      final List<LegalAdviceModel> fetchedList = snapshot.docs.map((doc) {
        return LegalAdviceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      legalAdviceList.assignAll(fetchedList); // More efficient than reassignment
    } catch (e) {
      print("Error fetching legal advices: $e");
    }
  }

  // Add new legal advice
  Future<void> addLegalAdvice(String title, String category, String question, String answer) async {
    try {
      DocumentReference docRef = await _firestore.collection('legal_advices').add({
        'title': title,
        'category': category,
        'question': question,
        'answer': answer,
        'createdAt': FieldValue.serverTimestamp(), // Use Firestore's Timestamp
      });

      print("Legal advice added with ID: ${docRef.id}");
      fetchLegalAdvices(); // Refresh data after adding
    } catch (e) {
      print("Error adding legal advice: $e");
    }
  }

  // Delete legal advice
  Future<void> deleteLegalAdvice(String id) async {
    try {
      await _firestore.collection('legal_advices').doc(id).delete();
      legalAdviceList.removeWhere((advice) => advice.id == id); // Optimized local removal
    } catch (e) {
      print("Error deleting legal advice: $e");
    }
  }
}
