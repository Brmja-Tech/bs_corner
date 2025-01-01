import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  final String id;
  final String title;
  final bool isActive;

  const RoomModel({
    required this.id,
    required this.title,
    required this.isActive,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json['id'],
        title: json['title'],
        isActive: json['is_active'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'is_active': isActive,
      };
  @override
  List<Object?> get props => [id, title, isActive];
}
