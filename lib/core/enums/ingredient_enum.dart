enum IngredientEnum{kilogram, gram, liter}

extension StringIngredientExtension on String {
  IngredientEnum get ingredientEnum {
    switch (this) {
      case 'kilogram':
        return IngredientEnum.kilogram;
      case 'gram':
        return IngredientEnum.gram;
      case 'liter':
        return IngredientEnum.liter;
      default:
        throw ArgumentError('Invalid ingredient string value');
    }
  }
}
