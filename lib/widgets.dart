import 'package:flutter/material.dart';

class ProductivityButton extends StatelessWidget {
  const ProductivityButton(
      {Key? key,
      required this.color,
      required this.text,
      required this.size,
      required this.onPressed})
      : super(key: key);

  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: this.onPressed,
      color: this.color,
      minWidth: this.size,
    );
  }
}

typedef CallBackSetting = void Function(String, int);

class SettingsButton extends StatelessWidget {
  SettingsButton(
    this.color,
    this.text,
    this.size,
    this.value,
    this.setting,
    this.callback,
  );

  final Color color;
  final String text;
  final int value;
  final double size;
  final String setting;
  final CallBackSetting callback;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        this.callback(this.setting, this.value);
      },
      color: this.color,
      minWidth: this.size,
    );
  }
}
