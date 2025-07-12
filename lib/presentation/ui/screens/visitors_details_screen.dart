import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app_routes.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/data/repositories/api_repository_impl.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/domain/entities/zone.dart';
import 'package:student_id/domain/requests/student_request.dart';
import 'package:student_id/domain/use_cases/get_zones.dart';
import 'package:student_id/domain/use_cases/students_usecases.dart';
import 'package:student_id/presentation/bloc/list/list_bloc.dart';
import 'package:student_id/presentation/bloc/student_list/students_bloc.dart';
import 'package:student_id/presentation/ui/screens/list_screen.dart';
import 'package:student_id/presentation/ui/widgets/photo_instructions.dart';
import 'package:student_id/presentation/ui/widgets/pic_image_widget.dart';
import 'package:student_id/presentation/ui/widgets/visitor_id_card_preview.dart';

class VisitorsDetails extends StatefulWidget {
  VisitorsDetails({super.key});
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  final _sectionTextController = TextEditingController();
  final _visitorNameTextController = TextEditingController();
  final _contactNoTextController = TextEditingController();
  @override
  State<StatefulWidget> createState() => _VisitorsDetailsState();
}

class _VisitorsDetailsState extends State<VisitorsDetails> {
  late List<CameraDescription> camera;
  bool _isNameValid = true;
  bool _isANValid = true;
  String selectedPhotoType = '';
  String studentPhotoPath = '';
  StudentEntity? studentEntity;
  String visitorPhotoPath = '';
  String releationShip = '';
  late StudentsBloc _studentBloc;
  late ListBloc _listBloc;
  final ValueNotifier<Zones?> _selectedZone = ValueNotifier(null);
  Zones? _selectedInstitute;
  Zones? _selectedClass;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _studentBloc = StudentsBloc(
        studentsUsecase:
            StudentsUsecase(repository: context.read<ApisRepositoryImpl>()));
    _listBloc = ListBloc(
        getZonesUsecase:
            GetZones(repository: context.read<ApisRepositoryImpl>()));
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

  void _onImageSelected(
    String filePath,
  ) {
    if (filePath.isNotEmpty) {
      if (selectedPhotoType == 'visitor') {
        setState(() {
          visitorPhotoPath = filePath;
        });
      } else {
        setState(() {
          studentPhotoPath = filePath;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final instituteType =
        PrefUtils().getBoolValue(SharedPreferencesString.isSchool)
            ? InstituteType.schools
            : InstituteType.colleges;
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor Details')),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<StudentsBloc>(
              create: (BuildContext context) => _studentBloc),
          BlocProvider<ListBloc>(create: (BuildContext context) => _listBloc)
        ],
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: FutureBuilder(
                                  future: _listBloc.getDataList(ListType.zones,
                                      lookupId:
                                          instituteType == InstituteType.schools
                                              ? '1'
                                              : '2'),
                                  builder: (context, snapShot) {
                                    final items = snapShot.data ?? [];
                                    return DropdownButtonFormField<Zones>(
                                      items: items.map<DropdownMenuItem<Zones>>(
                                          (Zones value) {
                                        return DropdownMenuItem<Zones>(
                                          value: value,
                                          child: Text(
                                            overflow: TextOverflow.clip,
                                            value.toString(),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedInstitute = null;
                                          _selectedZone.value = value;
                                        });
                                      },
                                      hint: const Text('Select Zone'),
                                    );
                                  }),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: FutureBuilder(
                                  future: _selectedZone.value == null
                                      ? Future.value(List<Zones>.empty())
                                      : _listBloc.getDataList(
                                          ListType.institutes,
                                          lookupId:
                                              '${_selectedZone.value?.id}'),
                                  builder: (context, snapShot) {
                                    final data = snapShot.data
                                        ?.map((zone) => zone.name ?? '')
                                        .toList();
                                    final items = (snapShot.data ?? [])
                                        .map<DropdownMenuItem<Zones>>(
                                            (Zones value) {
                                      return DropdownMenuItem<Zones>(
                                        value: value,
                                        child: Text(
                                          overflow: TextOverflow.clip,
                                          value.toString(),
                                        ),
                                      );
                                    }).toList();

                                    return DropdownButtonFormField<Zones>(
                                      key: UniqueKey(),
                                      items: items,
                                      value: _selectedInstitute,
                                      isDense: true,
                                      isExpanded: true,
                                      onChanged: (value) {
                                        _selectedInstitute = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please Select ${instituteType == InstituteType.schools ? 'School' : 'Colleges'}';
                                        }
                                      },
                                      hint: Text(
                                          'Select ${instituteType == InstituteType.schools ? 'School' : 'Colleges'}'),
                                    );
                                  }),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                            future: _listBloc.getDataList(
                                instituteType == InstituteType.schools
                                    ? ListType.classes
                                    : ListType.colleges),
                            builder: (context, snapShot) {
                              final items = (snapShot.data ?? [])
                                  .map<DropdownMenuItem<Zones>>((Zones value) {
                                return DropdownMenuItem<Zones>(
                                  value: value,
                                  child: Text(
                                    overflow: TextOverflow.clip,
                                    value.toString(),
                                  ),
                                );
                              }).toList();
                              return DropdownButtonFormField<Zones>(
                                items: items,
                                onChanged: (value) {
                                  _selectedClass = value;
                                },
                                value: _selectedClass,
                                isDense: true,
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please Select ${instituteType == InstituteType.schools ? 'Class' : 'Year'}';
                                  }
                                },
                                hint: Text(
                                    'Select ${instituteType == InstituteType.schools ? 'Class' : 'Year'}'),
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: widget._anTextController,
                                keyboardType: TextInputType.name,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9a-zA-Z. ]")),
                                ],
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    // border: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.all(Radius.circular(15)),
                                    // ),
                                    label:
                                        const Text('Student Addmission Number'),
                                    errorText: _isNameValid
                                        ? null
                                        : 'Please enter Student Admission Id'),
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Please enter Student Admission Id';
                                  }
                                },
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final studentRequest = StudentRequest(
                                    instituteId:
                                        '${_selectedInstitute?.id}'.trim(),
                                    classId: '${_selectedClass?.id}'.trim(),
                                    admissionNumber:
                                        widget._anTextController.text.trim());
                                studentEntity =
                                    await _studentBloc.getStudentByID(
                                        studentRequest: studentRequest);

                                widget._nameTextController.text =
                                    studentEntity?.name ?? '';
                                widget._sectionTextController.text =
                                    studentEntity?.sectionName ?? '';
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8)) // Shadow Color
                                  ),
                              child: Text(
                                'GET',
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Ex : TEST4545',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: widget._nameTextController,
                          keyboardType: TextInputType.name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z]")),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.all(Radius.circular(15)),
                              // ),
                              label: const Text('Student Name'),
                              errorText: _isANValid
                                  ? null
                                  : 'Please enter Student Name'),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter Student Name';
                            }
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: widget._sectionTextController,
                          keyboardType: TextInputType.name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z]")),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.all(Radius.circular(15)),
                              // ),
                              label: const Text('Section'),
                              errorText:
                                  _isANValid ? null : 'Please enter Section'),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter Section';
                            }
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        // if (studentEntity != null)
                        //   ListTile(
                        //     title: Text(studentEntity?.name ?? ''),
                        //     onTap: () {},
                        //     leading: (studentEntity?.profileUrl ?? '').isNotEmpty
                        //         ? Image.network(studentEntity?.profileUrl ?? '')
                        //         : const Icon(Icons.photo),
                        //   ),
                        // const SizedBox(height: 20),
                        Text(
                          'Visitor Relation',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          )),
                        ),
                        DropdownButtonFormField<String>(
                          items: ['Father', 'Mother', 'Visitor']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                overflow: TextOverflow.clip,
                                value.toString(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            releationShip = value ?? '';
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select releationShip';
                            }
                          },
                          hint: const Text('Select Visitor Relation'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: widget._visitorNameTextController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z]")),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.all(Radius.circular(15)),
                              // ),
                              label: const Text('Visitor Name'),
                              errorText:
                                  _isANValid ? null : 'Please enter Name'),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Please enter visitor name';
                            }
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: widget._contactNoTextController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(Radius.circular(15)),
                            // ),
                            label: Text('Contact No.'),
                          ),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        ListTile(
                          title: Text(visitorPhotoPath.isEmpty
                              ? 'Add Visitor Photo'
                              : 'Update Visitor Photo'),
                          onTap: () {
                            selectedPhotoType = 'visitor';
                            _showDialog();
                          },
                          leading: const Icon(Icons.photo),
                        ),
                        if (visitorPhotoPath.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            color: const Color.fromARGB(255, 211, 211, 211),
                            child: Image.file(File(visitorPhotoPath)),
                          ),
                        ],
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true &&
                      visitorPhotoPath.isNotEmpty &&
                      releationShip.isNotEmpty) {
                    StudentRequest studentRequest = StudentRequest(
                        id: '${studentEntity?.id ?? ''}',
                        admissionNumber: widget._anTextController.text,
                        visitorName: widget._visitorNameTextController.text,
                        relationship: releationShip,
                        studentName: widget._nameTextController.text,
                        sectionName: widget._sectionTextController.text,
                        instituteId: '${_selectedInstitute?.id}',
                        classId: '${_selectedClass?.id}',
                        contactNumber: widget._contactNoTextController.text,
                        idPath: visitorPhotoPath);
                    Dialogs.loader(context);
                    final response = await _studentBloc.uploadVisitor(
                        studentRequest: studentRequest);
                    Navigator.pop(context);
                    if (response != null) {
                      await showDialog(
                          context: context,
                          builder: (context) => VisitorIdCardPreview(
                              StudentEntity(
                                  name: widget._visitorNameTextController.text,
                                  schoolName: _selectedInstitute?.name ?? '',
                                  admissionNumber:
                                      widget._anTextController.text,
                                  profileUrl: visitorPhotoPath)));
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.studentTeacherScreen,
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)) // Shadow Color
                    ),
                child: Text(
                  'SUBMIT',
                  style: GoogleFonts.roboto(
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
