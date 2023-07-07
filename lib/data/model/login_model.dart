import 'package:equatable/equatable.dart';
import 'package:student_id/domain/entities/login_entity.dart';

class LoginModel extends Equatable {
  var schoolId;
  final String? accessToken;
  final String? refreshToken;

  LoginModel({
    required this.schoolId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      schoolId: json['schoolId'] == null ? "" : json["schoolId"],
      accessToken: json['access_token'] == null ? "" : json["access_token"],
      refreshToken: json['refresh_token'] == null ? "" : json["refresh_token"],
    );
  }

  @override
  List<Object?> get props => [schoolId, accessToken, refreshToken];
}

extension SourceModelExtension on LoginModel {
  LoginEntity get toLoginEntity => LoginEntity(
      schoolId: '$schoolId',
      accessToken: accessToken,
      refreshToken: refreshToken);
}
