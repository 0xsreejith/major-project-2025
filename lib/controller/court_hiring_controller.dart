import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CourtHiringController extends GetxController {
  var courtHirings = <Map<String, dynamic>>[].obs;
  var todayHirings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchCourtHirings();
    super.onInit();
  }

  void fetchCourtHirings() async {
    FirebaseFirestore.instance
        .collection('court_hirings')
        .orderBy('date', descending: false)
        .snapshots()
        .listen((snapshot) {
      var allHirings = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Store Firestore document ID
        return data;
      }).toList();

      courtHirings.value = allHirings;

      // Filter today's hirings
      var today = DateTime.now();
      todayHirings.value = allHirings.where((hiring) {
        DateTime hiringDate = (hiring['date'] as Timestamp).toDate();
        return hiringDate.year == today.year &&
            hiringDate.month == today.month &&
            hiringDate.day == today.day;
      }).toList();
    });
  }

  // 📝 Edit Court Hiring
  Future<void> updateCourtHiring(String id, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection('court_hirings').doc(id).update(updatedData);
  }

  // ❌ Delete Court Hiring
  Future<void> deleteCourtHiring(String id) async {
    await FirebaseFirestore.instance.collection('court_hirings').doc(id).delete();
  }
}
