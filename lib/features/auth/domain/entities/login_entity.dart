class LoginEntity {
  final String? schoolId;
  final String? accessToken;
  final String? refreshToken;

  const LoginEntity({
    required this.schoolId,
    required this.accessToken,
    required this.refreshToken,
  });
}
