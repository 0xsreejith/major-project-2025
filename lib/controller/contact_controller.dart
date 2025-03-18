import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;

  // Function to send a message
  Future<void> sendMessage(String userId, String name, String email, String message) async {
    try {
      isLoading.value = true;
      await _firestore.collection('legal_queries').add({
        'userId': userId,
        'name': name,
        'email': email,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Get.snackbar("Success", "Your message has been sent.");
    } catch (e) {
      Get.snackbar("Error", "Failed to send message.");
    } finally {
      isLoading.value = false;
    }
  }

  // Function to fetch messages for admin
  Stream<QuerySnapshot> fetchMessages() {
    return _firestore.collection('legal_queries').orderBy('timestamp', descending: true).snapshots();
  }
}
