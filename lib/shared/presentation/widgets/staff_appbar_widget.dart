import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/core/utils/pref_utils.dart';

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
            await PrefUtils().setStringValue(
              SharedPreferencesString.userName,
              '',
            );
            if (context.mounted) {
              context.go('/hub');
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
