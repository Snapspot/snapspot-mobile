
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final int statusCode;
  final String message;
  ServerException(this.statusCode, this.message);

  @override
  String toString() => 'ServerException ($statusCode): $message';
}

class ParsingException implements Exception {
  final String message;
  ParsingException(this.message);

  @override
  String toString() => 'ParsingException: $message';
}
