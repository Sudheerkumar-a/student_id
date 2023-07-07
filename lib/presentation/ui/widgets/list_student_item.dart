import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/presentation/ui/screens/teacher_review_screen.dart';

class ListStudentItem extends StatelessWidget {
  ListStudentItem(this.studentEntity, {super.key});
  final StudentEntity studentEntity;
  var statusColor = Colors.black87;
  Widget _getImageBasedonType(String image) {
    if (image.contains("http://") || image.contains("https://")) {
      return Image.network(
        image,
        width: 90,
        height: 90,
      );
    } else if (image.contains('assets/')) {
      return Image.asset(
        image,
        width: 90,
        height: 90,
      );
    } else {
      return Image.file(
        File(image),
        width: 90,
        height: 90,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (studentEntity.infoStatus == 'APPROVED') {
      statusColor = Colors.green;
    } else if (studentEntity.infoStatus == 'REJECTED') {
      statusColor = Colors.red;
    }
    return
        // Card(
        //   color: Theme.of(context).colorScheme.onSecondary,
        //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //   child:
        Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        //                    <-- BoxDecoration
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          _getImageBasedonType(
              studentEntity.profileUrl ?? 'assets/images/user_profile.png'),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studentEntity.name ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                studentEntity.admissionNumber ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                studentEntity.infoStatus ?? '',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: statusColor),
              ),
              const Divider(
                color: Colors.black,
              )
            ],
          ),
        ],
      ),
      //),
    );
  }
}
