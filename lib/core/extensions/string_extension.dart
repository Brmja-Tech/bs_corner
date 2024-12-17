extension StringX on String {
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  num get numerate => num.parse(this);
}
