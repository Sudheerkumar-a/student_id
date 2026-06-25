import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/features/camera/presentation/widgets/pic_image_widget.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/presentation/providers/student_details_helper.dart';
import 'package:student_id/features/students/presentation/widgets/photo_instructions.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  final _sectionTextController = TextEditingController();
  final _parentNameTextController = TextEditingController();

  bool _isNameValid = true;
  bool _isANValid = true;
  bool _isParentNameValid = true;
  String? _transportType = 'own';
  late StudentEntity args;

  bool get _isCollege => StudentDetailsHelper.isCollegeStudent(args);
  bool get _isStaff => StudentDetailsHelper.isStaff(args);
  bool get _isTelangana => StudentDetailsHelper.isTelangana(args);

  @override
  void dispose() {
    _nameTextController.dispose();
    _anTextController.dispose();
    _sectionTextController.dispose();
    _parentNameTextController.dispose();
    super.dispose();
  }

  void _openImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PicImagePopup(_onImageSelected),
    );
  }

  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const PhotoInstructions(),
    );
    _openImagePicker();
  }

  void _onImageSelected(String filePath) {
    if (filePath.isEmpty) return;

    context.push(
      '/student-preview',
      extra: StudentDetailsHelper.buildPreviewEntity(
        args: args,
        name: _nameTextController.text,
        admissionNumber: _anTextController.text,
        sectionName: _sectionTextController.text,
        transportType: _transportType,
        photoPath: filePath,
        parentName: _parentNameTextController.text.trim(),
      ),
    );
  }

  bool _validateForm() {
    final nameValid = _nameTextController.text.trim().isNotEmpty;
    final admissionValid = _anTextController.text.trim().isNotEmpty;
    final parentValid =
        !_isTelangana || _parentNameTextController.text.trim().isNotEmpty;

    setState(() {
      _isNameValid = nameValid;
      _isANValid = admissionValid;
      _isParentNameValid = parentValid;
    });

    return admissionValid && parentValid;
  }

  @override
  Widget build(BuildContext context) {
    args = GoRouterState.of(context).extra! as StudentEntity;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isCollege || _isStaff) ...{
                TextFormField(
                  controller: _nameTextController,
                  keyboardType: TextInputType.name,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z. ]')),
                  ],
                  decoration: InputDecoration(
                    label: Text(_isStaff ? 'Teacher Name' : 'Student Name'),
                    errorText: _isNameValid ? null : 'Please enter Name',
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Container(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Ex : Chinta vera venkata naga kishore kumar\nChinta V.V.N.Kishore Kumar',
                    style: GoogleFonts.roboto(),
                  ),
                ),
              },
              TextFormField(
                controller: _anTextController,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
                ],
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  label: const Text('Admission Id'),
                  errorText: _isANValid ? null : 'Please enter Admission Id',
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              if (_isTelangana) ...{
                const SizedBox(height: 10),
                TextFormField(
                  controller: _parentNameTextController,
                  keyboardType: TextInputType.name,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z. ]')),
                  ],
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    label: const Text('Parent Name'),
                    errorText: _isParentNameValid
                        ? null
                        : 'Please enter Parent Name',
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              },
              const SizedBox(height: 10),
              //if (_isCollege && _isStaff) ...{
              TextFormField(
                controller: _sectionTextController,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
                ],
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  label: const Text('Section'),
                  //errorText: _isANValid ? null : 'Please enter Section',
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 20),
              //},
              if (!_isCollege || _isStaff) ...{
                Text(
                  'Transport Type',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Own'),
                  leading: Radio<String>(
                    value: 'own',
                    groupValue: _transportType,
                    onChanged: (String? value) {
                      setState(() {
                        _transportType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Institute'),
                  leading: Radio<String>(
                    value: 'institute',
                    groupValue: _transportType,
                    onChanged: (String? value) {
                      setState(() {
                        _transportType = value;
                      });
                    },
                  ),
                ),
              },
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateForm()) {
                        _showDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
