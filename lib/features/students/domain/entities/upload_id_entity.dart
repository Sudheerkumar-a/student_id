import 'package:equatable/equatable.dart';

class UploadIdEntity extends Equatable {
  final String? message;

  const UploadIdEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
