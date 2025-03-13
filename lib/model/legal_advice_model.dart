import 'package:cloud_firestore/cloud_firestore.dart';

class LegalAdviceModel {
  final String id;
  final String title;
  final String category;
  final String question;
  final String answer;
  final DateTime? createdAt;

  LegalAdviceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.question,
    required this.answer,
    this.createdAt,
  });

  factory LegalAdviceModel.fromMap(Map<String, dynamic> data, String documentId) {
    return LegalAdviceModel(
      id: documentId,
      title: data['title'] ?? 'Unknown Title',
      category: data['category'] ?? 'Uncategorized',
      question: data['question'] ?? 'No question provided',
      answer: data['answer'] ?? 'No answer available',
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

  /// ✅ Convert Firestore Timestamp or String to DateTime
  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate(); // Convert Firestore Timestamp
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp); // Convert String to DateTime
    }
    return null;
  }
}
