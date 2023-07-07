import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_routes.dart';
import '../../../core/utils/pref_utils.dart';

class StaffAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StaffAppBar(this.title, {super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () async {
            PrefUtils().setStringValue(SharedPreferencesString.userName, '');
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.studentTeacherScreen,
              (Route<dynamic> route) => false,
            );
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
