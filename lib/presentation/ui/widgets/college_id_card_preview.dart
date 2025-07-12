import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/domain/entities/student_entity.dart';

class CollegeIdCardPreview extends StatelessWidget {
  final StudentEntity studentEntity;
  const CollegeIdCardPreview(this.studentEntity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Successfully Uploded!",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green.shade400, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  'IDENTITY CARD',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
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
              Center(
                child: Text(
                  'XXXXXX',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                    color: Colors.red.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Admin No: ${studentEntity.admissionNumber}',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
              ),
              const SizedBox(height: 5),
              Text(
                'Section: XXXXXX',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
              ),
              const SizedBox(height: 5),
              Text(
                'Campus: ${studentEntity.schoolName}',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
              ),
              const SizedBox(height: 5),
              Text(
                'Academic Year: 2025 - 2026',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
              ),
              const SizedBox(height: 5),
              Text(
                'Transport: XXXXXX',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
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
