import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productivity_timer/settings.dart';
import 'package:productivity_timer/timer.dart';
import 'package:productivity_timer/timermodel.dart';
import 'package:productivity_timer/widgets.dart';
// import 'package:percent_indicator/percent_indicator.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Work Timer',
      // theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5;
  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {
    timer.startWork();
    final List<PopupMenuItem<String>> menuItems = [];
    menuItems.add(PopupMenuItem<String>(
      value: 'Settings',
      child: Text('Settings'),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Work Timer'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') {
                goToSettings(context);
              }
            },
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        return Column(children: [
          Row(
            children: [
              SizedBox(width: defaultPadding),
              Expanded(
                child: ProductivityButton(
                  color: Color(0xff009688),
                  onPressed: timer.startWork,
                  size: 100,
                  text: 'Work',
                ),
              ),
              SizedBox(width: defaultPadding),
              Expanded(
                child: ProductivityButton(
                  color: Color(0xff607D8B),
                  onPressed: () => timer.startBreak(true),
                  size: 100,
                  text: 'Short Break',
                ),
              ),
              SizedBox(width: defaultPadding),
              Expanded(
                child: ProductivityButton(
                  color: Color(0xff455A64),
                  onPressed: () => timer.startBreak(false),
                  size: 100,
                  text: 'Long Break',
                ),
              ),
              SizedBox(width: defaultPadding),
            ],
          ),
          Expanded(
              child: Center(
            child: StreamBuilder(
              initialData: "00:00",
              stream: timer.stream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // if (snapshot.hasData) {
                TimerModel timer =
                    (snapshot.data == '00:00' || snapshot.data == null)
                        ? TimerModel('00:00', 1)
                        : snapshot.data;
                return CircularPercentIndicator(
                  radius: availableWidth / 4,
                  lineWidth: 20.0,
                  percent: timer.percent,
                  center: Text( timer.time,
                      style: Theme.of(context).textTheme.headline2),
                  progressColor: Color(0xff009688),
                );
                // } else {
                //   return Text('Wait...');
                // }
              },
            ),
          )),

          /*Expanded(
    child: CircularPercentIndicator(
    radius: availableWidth / 2,
    lineWidth: 10.0,
    percent: timer.percent,
    center: Text(timer.time,
    style: Theme.of(context).textTheme.headline4),
    progressColor: Color(0xff009688),
    , ),*/

          Row(
            children: [
              SizedBox(width: defaultPadding),
              Expanded(
                child: ProductivityButton(
                  color: Color(0xff212121),
                  onPressed: timer.stopTimer,
                  size: 100,
                  text: 'Stop',
                ),
              ),
              SizedBox(width: defaultPadding),
              Expanded(
                child: ProductivityButton(
                  color: Color(0xff009688),
                  onPressed: timer.startTimer,
                  size: 100,
                  text: 'Restart',
                ),
              ),
              SizedBox(width: defaultPadding),
            ],
          )
        ]);
      }),
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  void emptyMethod() {}
}
