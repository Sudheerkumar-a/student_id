import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app/providers.dart';
import 'package:student_id/core/constants/enums.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/auth/presentation/providers/login_controller.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  bool _isUserNameValid = true;
  bool _isPwdValid = true;

  @override
  void dispose() {
    _nameTextController.dispose();
    _anTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (previous, next) {
      if (next.isLoading) {
        Dialogs.loader(context);
      } else if (previous?.isLoading == true) {
        if (next.login != null) {
          final prefs = ref.read(preferencesProvider);
          prefs.setStringValue(
              SharedPreferencesString.userName, _nameTextController.text);
          prefs.setStringValue(SharedPreferencesString.instituteID,
              next.login!.schoolId ?? '');
          prefs.setStringValue(SharedPreferencesString.accessToken,
              next.login!.accessToken ?? '');
          prefs.setStringValue(SharedPreferencesString.refreshToken,
              next.login!.refreshToken ?? '');
          context.go(
            '/catalog',
            extra: ListScreenArgs(
              prefs.getBoolValue(SharedPreferencesString.isSchool)
                  ? InstituteType.schools
                  : InstituteType.colleges,
              prefs.getBoolValue(SharedPreferencesString.isSchool)
                  ? ListType.classes
                  : ListType.colleges,
            ),
          );
        } else if (next.errorMessage != null) {
          Navigator.pop(context);
          Dialogs.showGenericErrorPopup(
            context,
            ErrorPopup(
              id: 1,
              errorCode: ErrorHandlerEnum.error_400,
              title: 'Alert',
              description: next.errorMessage!,
            ),
          );
        }
      }
    });

    ref.watch(loginControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameTextController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  label: const Text('User Name'),
                  errorText:
                      _isUserNameValid ? null : 'Please enter User Name'),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _anTextController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  label: const Text('Password'),
                  errorText: _isPwdValid ? null : 'Please enter Password'),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isUserNameValid = _nameTextController.text.isNotEmpty;
                    _isPwdValid = _anTextController.text.isNotEmpty;
                  });
                  if (_isUserNameValid && _isPwdValid) {
                    ref.read(loginControllerProvider.notifier).login(
                          _nameTextController.text,
                          _anTextController.text,
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text(
                  'Login',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
