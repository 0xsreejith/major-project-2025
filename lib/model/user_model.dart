class UserModel {
  String uid;
  String email;
  String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
  });

  // Convert UserModel to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
    };
  }

  // Create UserModel from a Firebase document snapshot
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}
