import 'dart:async';

import 'package:student_id/core/utils/pref_utils.dart';

class TimerUtils {
  static int timerStart = 300;
  startTimer() async {
    Timer.periodic(Duration(seconds: 300), (timer) {
      if (timerStart == 0) {
        PrefUtils().setBoolValue('userSessionTimeOut', true);
        timer.cancel();
      } else {
        timerStart--;
        PrefUtils().setBoolValue('userSessionTimeOut', false);
      }
    });
  }

  void resetTimer() {
    if (TimerUtils.timerStart == 0) {
      TimerUtils.timerStart = 300;
      startTimer();
    }
  }
}
