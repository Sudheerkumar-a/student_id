class StudentRequest {
  final String id;
  final String loginId;
  final String zoneId;
  final String instituteId;
  final String classId;
  final String studentName;
  final String admissionNumber;
  final String idPath;
  final bool isAccepted;
  final String accessToken;
  final String transport;
  StudentRequest(
      {this.id = '',
      this.loginId = '',
      this.zoneId = '',
      this.instituteId = '',
      this.classId = '',
      this.studentName = '',
      this.admissionNumber = '',
      this.idPath = '',
      this.isAccepted = false,
      this.accessToken = '',
      this.transport = ''});
}
