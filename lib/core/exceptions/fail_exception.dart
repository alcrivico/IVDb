abstract class FailException implements Exception {
  String message = 'Ocurrió un fallo inesperado';

  FailException(this.message);
}

class ServerException extends FailException {
  ServerException(super.message);
}

class ClientException extends FailException {
  ClientException(super.message);
}
