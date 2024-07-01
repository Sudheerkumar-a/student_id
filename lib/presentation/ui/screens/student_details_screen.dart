import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app_routes.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/presentation/ui/widgets/photo_instructions.dart';
import 'package:student_id/presentation/ui/widgets/pic_image_widget.dart';

class StudentDetails extends StatefulWidget {
  StudentDetails({super.key});
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  final _sectionTextController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  late List<CameraDescription> camera;
  bool _isNameValid = true;
  bool _isANValid = true;
  String? _transportType = 'own';
  late StudentEntity args;

  @override
  void initState() {
    super.initState();
  }

  void _open_Image_picker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PicImagePopup(_onImageSelected);
        });
  }

  Future<void> _showDialog() async {
    await showDialog(
        context: context, builder: (context) => const PhotoInstructions());
    _open_Image_picker();
  }

  void _onImageSelected(String filePath) {
    if (filePath.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.studentIdPrewviewScreen,
        arguments: StudentEntity(
            name: widget._nameTextController.text,
            admissionNumber: widget._anTextController.text,
            sectionName: widget._sectionTextController.text,
            profileUrl: filePath,
            schoolId: args.schoolId ?? 0,
            schoolName: args.schoolName,
            classNo: args.classNo,
            className: args.className,
            transport: _transportType),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as StudentEntity;
    final isCollege =
        ["FIRST_YEAR", "SECOND_YEAR", "LONG_TERM"].contains(args.classNo);
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: widget._nameTextController,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z. ]")),
                ],
                decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(15)),
                    // ),
                    label: Text(args.className == 'STAFF'
                        ? 'Teacher Name'
                        : 'Student Name'),
                    errorText: _isNameValid ? null : 'Please enter Name'),
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
              TextFormField(
                controller: widget._anTextController,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ],
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(15)),
                    // ),
                    label: const Text('Admission Id'),
                    errorText: _isANValid ? null : 'Please enter Admission Id'),
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 20),
              if (isCollege) ...{
                TextFormField(
                  controller: widget._sectionTextController,
                  keyboardType: TextInputType.name,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(15)),
                      // ),
                      label: const Text('Section'),
                      errorText: _isANValid ? null : 'Please enter Section'),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(height: 20),
              },
              Text(
                'Transport Type',
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                )),
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
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isNameValid =
                            widget._nameTextController.text.isNotEmpty;
                        _isANValid = widget._anTextController.text.isNotEmpty;
                      });
                      if (_isANValid && _isNameValid) {
                        //_open_Image_picker();
                        _showDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8)) // Shadow Color
                        ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 14)),
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
