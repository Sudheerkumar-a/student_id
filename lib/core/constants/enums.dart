enum ErrorHandlerEnum {
  // ignore: constant_identifier_names
  none,
  // ignore: constant_identifier_names
  success_200,
  // ignore: constant_identifier_names
  error_401,
  error_400,
  error_449,
  success_1000,
  error_http_200,
  error_http_201,
  error_http_401,
  noDataError,
  serverError,
  timeOutError,
  error_9999
}

extension ErrorHandlerEnumExt on ErrorHandlerEnum {
  int get asInt {
    switch (this) {
      case ErrorHandlerEnum.error_http_200:
        return 200;
      case ErrorHandlerEnum.error_http_401:
        return 401;
      default:
        return 9999;
    }
  }
}

enum NetWorkEnum {
  offline,
  online,
  none,
}
