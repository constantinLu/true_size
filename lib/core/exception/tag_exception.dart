class TagServiceException implements Exception {
  final String message;

  TagServiceException(this.message);

  @override
  String toString() => 'TagServiceException: $message';
}
