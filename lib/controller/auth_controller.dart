import 'package:findmyadvocate/model/advocate_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> _user = Rxn<User>();
  final Rx<dynamic> _currentUser = Rx<dynamic>(null);
  final RxList<AdvocateModel> advocatesList = <AdvocateModel>[].obs;

  User? get user => _user.value;
  dynamic get currentUser => _currentUser.value;
var isLoading = true.obs;
  @override
  void onInit() {
    fetchTopAdvocates(5); // Fetch top 5 advocates initially
    super.onInit();
  }
  @override
  void onReady() {
    _user.bindStream(_auth.authStateChanges());
    ever(_user, _handleAuthChange);
    super.onReady();
  }

  /// 🔹 Handles authentication state changes
  void _handleAuthChange(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      print("🔹 User logged in: ${user.email} (UID: ${user.uid})");
      await _fetchUserData(user.uid);

      if (_currentUser.value != null) {
        String role = _currentUser.value?['role'] ?? '';

        print("🔹 User role detected: $role");

        if (role == 'admin') {
          Get.offAllNamed('/admin-dashboard');
        } else if (role == 'user') {
          Get.offAllNamed('/user-dashboard');
        } else {
          print("❌ Unauthorized role detected: $role");
          Get.snackbar('Error', 'Unauthorized access');
          logout();
        }
      } else {
        print("❌ User data is NULL after fetching.");
        Get.snackbar('Error', 'User data not found');
        logout();
      }
    }
  }

  /// 🔹 Fetches user data based on role
  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot? userDoc;

      userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        _currentUser.value = userDoc.data();
        return;
      }

      userDoc = await _firestore.collection('admins').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        _currentUser.value = userDoc.data();
        return;
      }

      print('❌ No user data found in Firestore for UID: $uid');
      _currentUser.value = null;
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('❌ Error fetching user data: $e');
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }

  /// 🔹 Fetches all advocates (for user dashboard)
Future<void> fetchAdvocates() async {
  try {
    final QuerySnapshot querySnapshot =
        await _firestore.collection('advocates').get();

    print("Fetched ${querySnapshot.docs.length} advocates"); // Debugging

    advocatesList.assignAll(querySnapshot.docs.map((doc) {
      print("Advocate Data: ${doc.data()}");
      return AdvocateModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList());
  } catch (e) {
    print("Error fetching advocates: $e"); // Debugging
    Get.snackbar('Error', 'Failed to fetch advocates: $e');
  }
}
Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    Get.snackbar('Success', 'Password reset email sent! Check your inbox.');
  } catch (e) {
    print('❌ Error sending password reset email: $e');
    Get.snackbar('Error', 'Failed to send password reset email: $e');
  }
}
void fetchTopAdvocates(int limit) async {
    try {
      isLoading(true);
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



  /// 🔹 Logs in a user
  Future<void> login(String email, String password) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _fetchUserData(credential.user!.uid);
      print('✅ Login successful for: ${credential.user!.email}');
      Get.snackbar('Success', 'Login successful!');
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    }
  }

  /// 🔹 Admin creates an advocate (Firestore only, no authentication)
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

      print('✅ Advocate added successfully: $name ($email)');
      Get.snackbar('Success', 'Advocate added successfully!');
    } catch (e) {
      print('❌ Error adding advocate: $e');
      Get.snackbar('Error', 'Failed to add advocate: $e');
    }
  }

  /// 🔹 Creates a normal user account
  Future<void> createUser(String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'role': 'user',
        'createdAt': DateTime.now().toIso8601String(),
      });

      print('✅ User account created successfully: $email');
      Get.snackbar('Success', 'Account created successfully!');
      Get.offAllNamed('/user-dashboard');
    } catch (e) {
      print('❌ Error creating user: $e');
      Get.snackbar('Error', 'Failed to create account: $e');
    }
  }

  /// 🔹 Logs out the current user
  void logout() async {
    await _auth.signOut();
    _currentUser.value = null;
    _user.value = null;
    Get.offAllNamed('/login');
  }
}
