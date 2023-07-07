import 'package:equatable/equatable.dart';

class UploadIdEntitiy extends Equatable {
  final String? message;

  const UploadIdEntitiy({required this.message});
  @override
  List<Object?> get props => [message];
}
