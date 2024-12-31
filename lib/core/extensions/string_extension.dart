extension StringX on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  String get enumValue => toString().split('.').last;

  num get numerate => num.parse(this);
  int get toInt => int.parse(this);
  DateTime get toDateTime => DateTime.parse(this);
  double get toDouble => double.parse(this);
}
