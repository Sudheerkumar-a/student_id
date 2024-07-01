import 'dart:async';

import 'package:flutter/material.dart';
import '../../../app_routes.dart';
import '../../../core/utils/pref_utils.dart';
import 'list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  //final Function(Widget) changeScreen;
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer.periodic(
        const Duration(seconds: 3),
        (Timer t) async => {
              t.cancel(),
              if ((PrefUtils().getStringValue("user_name") ?? '').isEmpty ==
                  true)
                {
                  Navigator.of(context).popAndPushNamed(
                    AppRoutes.schoolsColleges,
                  )
                }
              else
                {
                  Navigator.of(context).popAndPushNamed(
                    AppRoutes.listScreen,
                    arguments: ListWidgetArguments(
                        InstituteType.schools, ListType.classes),
                  )
                }
            });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              width: 200,
              height: 200,
              image: AssetImage('assets/images/ic_splash.png'),
            )
          ],
        ),
      ),
    );
  }
}
