import 'package:equatable/equatable.dart';

import '../constants/enums.dart';

class ErrorPopup {
  final int id;
  final ErrorHandlerEnum errorCode;
  final String title;
  final String description;
  final String okButtonLabel;
  final String? okPage;
  final String? cancelButtonLabel;
  final String? cancelPage;
  bool get showSingleButton => cancelButtonLabel == null;

  const ErrorPopup({
    required this.id,
    required this.errorCode,
    required this.title,
    required this.description,
    this.okButtonLabel = "ok",
    this.okPage,
    this.cancelButtonLabel,
    this.cancelPage,
  });

  ErrorPopup.fromErrorObject({
    required int id,
    required ErrorObject errorObject,
    String okButtonLabel = "0k",
    String? okPage,
    String? cancelButtonLabel,
    String? cancelPage,
  }) : this(
          id: id,
          errorCode: errorObject.error,
          title: errorObject.title,
          description: errorObject.description,
          okButtonLabel: okButtonLabel,
          cancelButtonLabel: cancelButtonLabel,
          okPage: okPage,
          cancelPage: cancelPage,
        );

  const ErrorPopup.initialized()
      : this(
          id: 0,
          errorCode: ErrorHandlerEnum.none,
          title: "",
          description: "",
          okButtonLabel: "",
          okPage: "",
          cancelButtonLabel: "",
          cancelPage: "",
        );
}

class ErrorObject with EquatableMixin {
  final String title;
  final String description;
  final ErrorHandlerEnum error;

  @override
  get props => [
        title,
        description,
        error,
      ];

  const ErrorObject({
    required this.title,
    required this.description,
    required this.error,
  });
}
