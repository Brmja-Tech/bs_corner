class SupabaseException implements Exception {
  final String message;
  final int? statusCode;

  SupabaseException({required this.message, this.statusCode});

  @override
  String toString() => 'SupabaseException: $message (Code: $statusCode)';
}
