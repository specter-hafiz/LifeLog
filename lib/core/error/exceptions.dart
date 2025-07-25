class ServerException implements Exception {}

class CacheException implements Exception {}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class DuplicateEntryException implements Exception {
  final String message;
  DuplicateEntryException([this.message = "Entry for today already exists"]);
}
