import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable{
  final String id;
  final String name;
  final num price;
  final String imagePath;
  final String type;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.type,
  });
factory RestaurantModel.fromJson(Map<String, dynamic> json) {
  return RestaurantModel(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    imagePath: json['image'],
    type: json['type'],
  );
}
  @override
  List<Object?> get props => [id, name, price, imagePath, type];
}