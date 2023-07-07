import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app_routes.dart';
import 'package:student_id/data/datasource/remote_data_source.dart';
import 'package:student_id/data/repositories/api_repository_impl.dart';
import 'package:student_id/domain/use_cases/get_zones.dart';
import 'package:provider/provider.dart';
import 'package:student_id/domain/use_cases/login_usecases.dart';

import 'core/utils/pref_utils.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
  //  (value) {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils().init();
  await di.init();
  runApp(const MyApp());
  // },
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final kColorScheme =
        ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));
    final kDarkColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 5, 99, 125));
    return MultiProvider(
      providers: [
        Provider<ApisRepositoryImpl>(
            create: (context) =>
                ApisRepositoryImpl(remoteDataSource: RemoteDataSourceImpl())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Id',
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: kDarkColorScheme,
          cardTheme: const CardTheme()
              .copyWith(color: kDarkColorScheme.secondaryContainer),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer,
            ),
          ),
          textTheme: const TextTheme().copyWith(
              titleLarge: TextStyle(
            color: kDarkColorScheme.onSecondaryContainer,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          )),
        ),
        theme: ThemeData().copyWith(
            useMaterial3: true,
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kColorScheme.onPrimaryContainer,
              foregroundColor: kColorScheme.primaryContainer,
            ),
            cardTheme: const CardTheme()
                .copyWith(color: kColorScheme.secondaryContainer),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
              ),
            ),
            // textTheme: const TextTheme().copyWith(
            //   titleLarge: TextStyle(
            //     color: kColorScheme.onSecondaryContainer,
            //     fontWeight: FontWeight.normal,
            //     fontSize: 16,
            //   ),
            //   titleMedium: TextStyle(
            //     color: kColorScheme.onSecondaryContainer,
            //     fontWeight: FontWeight.normal,
            //     fontSize: 12,
            //   ),
            //   titleSmall: TextStyle(
            //     color: kColorScheme.onSecondaryContainer,
            //     fontWeight: FontWeight.normal,
            //     fontSize: 10,
            //   ),
            // ),
            textTheme: GoogleFonts.robotoTextTheme()),
        themeMode: ThemeMode.light,
        //home: ZonesScreen(),
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
