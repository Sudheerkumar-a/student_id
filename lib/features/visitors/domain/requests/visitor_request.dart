class VisitorRequest {
  final String admissionNumber;
  final String studentName;
  final String sectionName;
  final String instituteId;
  final String classId;
  final String visitorName;
  final String relationship;
  final String contactNumber;
  final String photoPath;
  final String accessToken;

  const VisitorRequest({
    this.admissionNumber = '',
    this.studentName = '',
    this.sectionName = '',
    this.instituteId = '',
    this.classId = '',
    this.visitorName = '',
    this.relationship = '',
    this.contactNumber = '',
    this.photoPath = '',
    this.accessToken = '',
  });
}
