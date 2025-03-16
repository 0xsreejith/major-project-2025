class CaseModel {
  final String id;
  final String caseNumber;
  final String caseTitle;
  final String courtName;
  final String status;
  final String hearingDate;
  final String details;

  CaseModel({
    required this.id,
    required this.caseNumber,
    required this.caseTitle,
    required this.courtName,
    required this.status,
    required this.hearingDate,
    required this.details,
  });

  factory CaseModel.fromJson(String id, Map<String, dynamic> json) {
    return CaseModel(
      id: id,
      caseNumber: json['caseNumber'],
      caseTitle: json['caseTitle'],
      courtName: json['courtName'],
      status: json['status'],
      hearingDate: json['hearingDate'],
      details: json['details'],
    );
  }
}
