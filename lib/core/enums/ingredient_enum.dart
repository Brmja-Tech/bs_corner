enum IngredientEnum{kilogram, gram, liter}

extension StringIngredientExtension on String {
  IngredientEnum get ingredientEnum {
    switch (this) {
      case 'كيلوجرام':
        return IngredientEnum.kilogram;
      case 'جرام':
        return IngredientEnum.gram;
      case 'لتر':
        return IngredientEnum.liter;
      default:
        throw ArgumentError('Invalid ingredient string value');
    }
  }
}
