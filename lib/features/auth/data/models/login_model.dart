import 'package:equatable/equatable.dart';
import 'package:student_id/features/auth/domain/entities/login_entity.dart';

class LoginModel extends Equatable {
  final dynamic schoolId;
  final String? accessToken;
  final String? refreshToken;

  const LoginModel({
    required this.schoolId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      schoolId: json['schoolId'] ?? '',
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }

  @override
  List<Object?> get props => [schoolId, accessToken, refreshToken];
}

extension LoginModelMapper on LoginModel {
  LoginEntity get toEntity => LoginEntity(
        schoolId: '$schoolId',
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}
