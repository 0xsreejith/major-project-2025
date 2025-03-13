class AppointmentModel {
  String id;
  String userId;
  String advocateId;
  String userName;
  String advocateName;
  String appointmentDate;
  String status;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.advocateId,
    required this.userName,
    required this.advocateName,
    required this.appointmentDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'advocateId': advocateId,
      'userName': userName,
      'advocateName': advocateName,
      'appointmentDate': appointmentDate,
      'status': status,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      userId: map['userId'],
      advocateId: map['advocateId'],
      userName: map['userName'],
      advocateName: map['advocateName'],
      appointmentDate: map['appointmentDate'],
      status: map['status'],
    );
  }
}
