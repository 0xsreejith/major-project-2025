class AdvocateModel {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final String location;
  final String experience;
  final String description;
  final String enrollmentNumber;
  final String mobileNumber;
  final String practicePlace;
  final String qualifications;
  final String barCouncilNumber;
  final String imageUrl;

  AdvocateModel({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.location,
    required this.experience,
    required this.description,
    required this.enrollmentNumber,
    required this.mobileNumber,
    required this.practicePlace,
    required this.qualifications,
    required this.barCouncilNumber,
    required this.imageUrl,
  });

  factory AdvocateModel.fromMap(Map<String, dynamic> data, String documentId) {
    return AdvocateModel(
      id: documentId, // 🔹 Pass Firestore Document ID separately
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      specialty: data['specialty'] ?? '',
      location: data['location'] ?? '',
      experience: data['experience'] ?? '',
      description: data['description'] ?? '',
      enrollmentNumber: data['enrollmentNumber'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      practicePlace: data['practicePlace'] ?? '',
      qualifications: data['qualifications'] ?? '',
      barCouncilNumber: data['barCouncilNumber'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
