import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  final String id;
  final String title;

  const RoomModel({
    required this.id,
    required this.title,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json['id'],
        title: json['title'],
      );

  @override
  List<Object?> get props => [id, title];
}
