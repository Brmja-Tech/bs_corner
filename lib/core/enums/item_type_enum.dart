enum ItemTypeEnum {
  food,
  beverage,
  other,
  all,
}

extension ItemTypeEnumExtension on ItemTypeEnum {
  String get value {
    switch (this) {
      case ItemTypeEnum.food:
        return 'مأكولات';
      case ItemTypeEnum.beverage:
        return 'مشروبات';
      case ItemTypeEnum.other:
        return 'اخرى';
      case ItemTypeEnum.all:
        return 'الكل';
    }
  }
}