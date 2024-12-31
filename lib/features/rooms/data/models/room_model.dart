import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  final int id;
  final String title;
  final bool isActive;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  const RoomModel(
      {required this.id, required this.title, required this.isActive});
}
