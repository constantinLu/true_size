class UserServiceException implements Exception {
  final String message;

  UserServiceException(this.message);

  @override
  String toString() => 'UserServiceException: $message';
}
