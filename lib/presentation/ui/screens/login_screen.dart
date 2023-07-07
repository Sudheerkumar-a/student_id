import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_id/app_routes.dart';
import 'package:student_id/core/constants/enums.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/data/repositories/api_repository_impl.dart';
import 'package:student_id/domain/use_cases/login_usecases.dart';
import 'package:student_id/presentation/bloc/login/login_bloc.dart';
import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late List<CameraDescription> camera;
  final _nameTextController = TextEditingController();
  final _anTextController = TextEditingController();
  bool _isUserNameValid = true;
  bool _isPwdValid = true;
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
        loginUsecase:
            LoginUsecase(repository: context.read<ApisRepositoryImpl>()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => _loginBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) => {
            if (state is LoginLoading)
              {Dialogs.loader(context)}
            else if (state is LoginWithSuccess)
              {
                PrefUtils().setStringValue(
                    SharedPreferencesString.userName, _nameTextController.text),
                PrefUtils().setStringValue(SharedPreferencesString.instituteID,
                    state.loginEntity.schoolId ?? ''),
                PrefUtils().setStringValue(SharedPreferencesString.accessToken,
                    state.loginEntity.accessToken ?? ''),
                PrefUtils().setStringValue(SharedPreferencesString.refreshToken,
                    state.loginEntity.refreshToken ?? ''),
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.listScreen,
                  (Route<dynamic> route) => false,
                  arguments: ListWidgetArguments(
                      InstituteType.schools, ListType.classes),
                )
              }
            else if (state is LoginWithError)
              {
                Navigator.pop(context),
                Dialogs.showGenericErrorPopup(
                    context,
                    ErrorPopup(
                        id: 1,
                        errorCode: ErrorHandlerEnum.error_400,
                        title: 'Alert',
                        description: state.message))
              }
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
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
                        _loginBloc.login(
                            _nameTextController.text, _anTextController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8)) // Shadow Color
                        ),
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
        ),
      ),
    );
  }
}
