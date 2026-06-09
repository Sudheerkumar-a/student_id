import 'package:equatable/equatable.dart';

class VisitorUploadResult extends Equatable {
  final String? message;

  const VisitorUploadResult({required this.message});

  @override
  List<Object?> get props => [message];
}
