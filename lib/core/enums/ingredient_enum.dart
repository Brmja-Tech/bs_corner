enum IngredientEnum{kilogram, gram, liter}

extension IngredientEnumExtension on IngredientEnum {
  String get value {
    switch (this) {
      case IngredientEnum.kilogram:
        return 'كيلوجرام';
      case IngredientEnum.gram:
        return 'جرام';
      case IngredientEnum.liter:
        return 'لتر';
    }
  }
}