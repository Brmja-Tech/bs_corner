import 'package:equatable/equatable.dart';

class ShiftModel extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String userId;
  final double totalCollectedMoney;
  final String shiftUserName;

  const ShiftModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.userId,
    required this.totalCollectedMoney,
    required this.shiftUserName,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      userId: json['user_id'],
      totalCollectedMoney: json['total_collected_money'],
      shiftUserName: json['shift_user_name'],
    );
  }

  @override
  List<Object?> get props =>
      [id, startTime, endTime, userId, totalCollectedMoney, shiftUserName];
}
