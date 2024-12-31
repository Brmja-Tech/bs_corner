class TimerModel {
  final String id;
  final String roomId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isMulti;

  TimerModel({
    required this.id,
    required this.roomId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.isMulti,
  });

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'],
      roomId: json['roomId'],
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      isMulti: json['isMulti'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isMulti': isMulti,
    };
  }
}
