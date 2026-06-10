import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/core/constants/enums.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/core/utils/dialogs.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/auth/presentation/providers/login_controller.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_scaffold.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _canLogin =>
      _usernameController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() != true) return;
    ref.read(loginControllerProvider.notifier).login(
          _usernameController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      if (next.isLoading) {
        Dialogs.loader(context);
      } else if (previous?.isLoading == true) {
        if (next.login != null) {
          final prefs = ref.read(preferencesProvider);
          prefs.setStringValue(
            SharedPreferencesString.userName,
            _usernameController.text,
          );
          prefs.setStringValue(
            SharedPreferencesString.instituteID,
            next.login!.schoolId ?? '',
          );
          prefs.setStringValue(
            SharedPreferencesString.accessToken,
            next.login!.accessToken ?? '',
          );
          prefs.setStringValue(
            SharedPreferencesString.refreshToken,
            next.login!.refreshToken ?? '',
          );
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
              title: 'Login Failed',
              description: next.errorMessage!,
            ),
          );
        }
      }
    });

    return AppFormScaffold(
      title: 'Staff Login',
      subtitle: 'Sign in to manage student records',
      bottomLabel: 'Login',
      bottomEnabled: _canLogin,
      bottomLoading: loginState.isLoading,
      onBottomPressed: _login,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            AppFormSectionCard(
              title: 'Account Credentials',
              subtitle: 'Use your school staff credentials',
              icon: Icons.lock_outline_rounded,
              children: [
                AppTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Enter username',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Username is required' : null,
                  onChanged: (_) => setState(() {}),
                ),
                const AppFieldGap(),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter password',
                  icon: Icons.key_outlined,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  validator: (v) =>
                      v?.isEmpty == true ? 'Password is required' : null,
                  onChanged: (_) => setState(() {}),
                ),
                const AppFieldGap(size: FormTokens.spacingSm),
                const AppHelperBanner(
                  text: 'Contact your school administrator if you forgot your credentials.',
                  icon: Icons.support_agent_outlined,
                ),
              ],
            ),
            const AppFieldGap(size: FormTokens.spacingXl),
          ],
        ),
      ),
    );
  }
}
