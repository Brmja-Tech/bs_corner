import 'package:equatable/equatable.dart';
import 'package:pscorner/core/enums/ingredient_enum.dart';

class RecipeModel extends Equatable {
  final String id;
  final String name;
  final IngredientEnum ingredientEnum;
  final num quantity;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.ingredientEnum,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, name, ingredientEnum, quantity];

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json['id'],
        name: json['name'],
        ingredientEnum: (json['ingredient_unit'] as String).ingredientEnum,
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'ingredient_unit': ingredientEnum.name,
        'quantity': quantity,
      };
}
