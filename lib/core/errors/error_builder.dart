import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base_state/base_state.dart';
import '../constants/app_dimension.dart';
import '../constants/enums.dart';
import '../utils/dialogs.dart';
import '../utils/size_utils.dart';
import 'error_pop.dart';

class ErrorPopupBuilder<BLOC extends BlocBase<STATE>, STATE extends BaseState>
    extends StatelessWidget {
  final ErrorPopup Function(STATE state) selector;
  final Future<Object?> Function(BuildContext context, ErrorPopup error)
      handler;
  final Widget child;

  const ErrorPopupBuilder({
    Key? key,
    this.selector = defaultSelector,
    this.handler = defaultHandler,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BLOC, STATE>(
      listenWhen: (previous, current) =>
          selector(previous) != selector(current) &&
          selector(current).errorCode != ErrorHandlerEnum.none,
      listener: (context, state) => handle(context, selector(state)),
      child: child,
    );
  }

  static ErrorPopup defaultSelector(BaseState state) {
    return state.error;
  }

  static Future<Object?> defaultHandler(
      BuildContext context, ErrorPopup error) {
    return Dialogs.showGenericErrorPopup(context, error);
  }

  Future<Object?> handle(BuildContext context, ErrorPopup error) {
    switch (error.errorCode) {
      case ErrorHandlerEnum.error_400:
        return AnimatedSnackBar(
          builder: ((context) {
            // return SnackBarWidget(
            //   title: error.title,
            //   description: error.description,
            // );
            return Container(
              padding: const EdgeInsets.all(16),
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(DIMENSION_10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error.title,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    error.description,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            );
          }),
        ).show(context);
      default:
        return handler(context, error);
    }
  }
//
//   static void handleSessionExpire(BuildContext context) async {
//     final navigator = Navigator.of(context);
//     while (navigator.canPop()) {
//       navigator.pop();
//     }
//     bool isSecureAuthToken = await AppUtils.isSecureAuthToken();
//     if (isSecureAuthToken) {
//       navigator.pushReplacementNamed(
//         AppRoutes.ROUTE_PIN_LOGIN,
//       );
//     } else {
//       navigator.pushReplacementNamed(
//         AppRoutes.ROUTE_PRE_LOAD_PAGE,
//       );
//     }
//   }
}
