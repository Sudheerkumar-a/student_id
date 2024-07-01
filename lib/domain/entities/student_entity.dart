class StudentEntity {
  final int? id;
  final String? name;
  final String? admissionNumber;
  final String? profileUrl;
  final String? bloodGroup;
  final int? schoolId;
  final String? classNo;
  final String? infoStatus;
  final String? transport;
  final String? schoolName;
  final String? className;
  final String? sectionName;

  const StudentEntity(
      {this.id,
      this.name,
      this.admissionNumber,
      this.profileUrl,
      this.bloodGroup,
      this.classNo,
      this.infoStatus,
      this.schoolId,
      this.transport,
      this.schoolName = '',
      this.className = '',
      this.sectionName = ''});
  @override
  List<Object?> get props => [
        id,
        name,
        admissionNumber,
        profileUrl,
        bloodGroup,
        classNo,
        infoStatus,
        schoolId,
        transport,
        schoolName,
        className
      ];
}
