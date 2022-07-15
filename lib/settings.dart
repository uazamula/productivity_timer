import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_timer/main.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TimerHomePage()));
          },
        ),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const String WORKTIME = 'workTime';
  static const String SHORTBREAK = 'shortBreak';
  static const String LONGBREAK = 'longBreak';

  static const int WORKTIMEDEFAULT = 30;
  static const int SHORTBREAKDEFAULT = 5;
  static const int LONGBREAKDEFAULT = 20;

  int? workTime;
  int? shortBreak;
  int? longBreak;

  double buttonSize = 100;

  late SharedPreferences prefs;

  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Text("Work", style: textStyle),
            Text(""),
            Text(""),
            SettingsButton(Color(0xff455A64), "-", buttonSize, -1, WORKTIME,
                updateSetting),
            TextField(
                controller: txtWork,
                style: textStyle,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number),
            SettingsButton(
                Color(0xff009688), "+", buttonSize, 1, WORKTIME, updateSetting),
            Text("Short", style: textStyle),
            Text(""),
            Text(""),
            SettingsButton(
              Color(0xff455A64),
              "-",
              buttonSize,
              -1,
              SHORTBREAK,
              updateSetting,
            ),
            TextField(
                controller: txtShort,
                style: textStyle,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number),
            SettingsButton(Color(0xff009688), "+", buttonSize, 1, SHORTBREAK,
                updateSetting),
            Text(
              "Long",
              style: textStyle,
            ),
            Text(""),
            Text(""),
            SettingsButton(Color(0xff455A64), "-", buttonSize, -1, LONGBREAK,
                updateSetting),
            TextField(
                controller: txtLong,
                style: textStyle,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number),
            SettingsButton(Color(0xff009688), "+", buttonSize, 1, LONGBREAK,
                updateSetting),
          ],
          padding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, WORKTIMEDEFAULT);
      workTime = WORKTIMEDEFAULT;
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, SHORTBREAKDEFAULT);
      shortBreak = SHORTBREAKDEFAULT;
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, LONGBREAKDEFAULT);
      longBreak = LONGBREAKDEFAULT;
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    switch (key) {
      case WORKTIME:
        {
          int workTime = prefs.getInt(WORKTIME) ?? WORKTIMEDEFAULT;
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK) ?? SHORTBREAKDEFAULT;
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtShort.text = short.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK) ?? LONGBREAKDEFAULT;
          long += value;
          if (long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtLong.text = long.toString();
            });
          }
        }
        break;
    }
  }
}
