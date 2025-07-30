class GroupServiceException implements Exception {
  final String message;

  GroupServiceException(this.message);

  @override
  String toString() => 'GroupServiceException: $message';
}
