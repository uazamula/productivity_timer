import 'dart:async';

import 'package:productivity_timer/timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = true;
  Timer? timer;
  Duration? _time;
  Duration? _fullTime;
  int work = 30;
  int shortBreak = 5;
  int longBreak = 25;

  Future readSettings() async {
    SharedPreferences prefs = await
    SharedPreferences.getInstance();
    work = prefs.getInt('workTime') ?? 30;
    shortBreak = prefs.getInt('shortBreak')?? 5;
    longBreak = prefs.getInt('longBreak') ?? 20;
  }


  void startBreak(bool isShort) async{
    await readSettings();

    _radius = 1;
    _time = Duration(
      minutes: isShort ? shortBreak : longBreak,
      seconds: 0,
    );
    _fullTime = _time;
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if (_time!.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void startWork() async{
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (this._isActive) {
        _time = _time! - Duration(seconds: 1);
        _radius = _time!.inSeconds / _fullTime!.inSeconds;
        if (_time!.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTime(_time!);
      return TimerModel(time, _radius);
    });
  }

  String returnTime(Duration t) {
    String minutes = t.inMinutes.toString().padLeft(2, '0');
    int numSeconds = t.inSeconds - t.inMinutes * 60;
    String seconds = numSeconds.toString().padLeft(2, '0');
    return minutes + ':' + seconds;
  }
}
