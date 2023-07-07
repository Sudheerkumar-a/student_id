import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/core/utils/size_utils.dart';
import 'package:student_id/domain/entities/student_entity.dart';

class SchoolIdCardPreview extends StatelessWidget {
  final StudentEntity studentEntity;
  const SchoolIdCardPreview(this.studentEntity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Successfully Uploded!",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green.shade400, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.blueAccent.shade700,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Text(
                          studentEntity.className == 'STAFF'
                              ? '  Teacher ID-CARD  '
                              : '  Student ID-CARD  ',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2)),
                        child: Image.file(
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            File(studentEntity.profileUrl!)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${studentEntity.name}',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )),
                        ),
                        if (studentEntity.className != 'STAFF')
                          const SizedBox(height: 5),
                        if (studentEntity.className != 'STAFF')
                          Text(
                            'Class: ${studentEntity.className}',
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            )),
                          ),
                        const SizedBox(height: 5),
                        Text(
                          studentEntity.className == 'STAFF'
                              ? 'STAFF ID No: ${studentEntity.admissionNumber}'
                              : 'Student ID No: ${studentEntity.admissionNumber}',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Branch: ${studentEntity.schoolName}',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                    ),
                    child: const Text('OK',
                        style: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
