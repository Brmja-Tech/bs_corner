enum ItemTypeEnum {
  food,
  drink,
  other,
  all,
}

extension ItemTypeEnumExtension on ItemTypeEnum {
  String get value {
    switch (this) {
      case ItemTypeEnum.food:
        return 'مأكولات';
      case ItemTypeEnum.drink:
        return 'مشروبات';
      case ItemTypeEnum.other:
        return 'اخرى';
      case ItemTypeEnum.all:
        return 'الكل';
    }
  }
}