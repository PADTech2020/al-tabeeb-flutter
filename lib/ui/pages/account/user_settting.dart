import 'package:flutter/material.dart';
import '../../../util/utility/custom_theme.dart';

class UserSetting extends StatefulWidget {
  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: CustomTheme.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("str.app.alarms"),
          SingleAlarm("str.app.quran"),
        ],
      ),
    );
  }
}

class SingleAlarm extends StatefulWidget {
  final String title;

  SingleAlarm(this.title);

  @override
  _SingleAlarmState createState() => _SingleAlarmState();
}

class _SingleAlarmState extends State<SingleAlarm> {
  double height = 30;
  double width = 165;
  AlignmentDirectional align;
  int levle = 0;
  @override
  Widget build(BuildContext context) {
    if (levle == 0)
      align = AlignmentDirectional.centerStart;
    else if (levle == 1)
      align = AlignmentDirectional.center;
    else
      align = AlignmentDirectional.centerEnd;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.title),
          SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: align,
                  child: Container(
                    height: height,
                    width: width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: CustomTheme.accentColor,
                    ),
                  ),
                ),
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _textBox("str.app.stop", 0),
                      _textBox("str.app.medium", 1),
                      _textBox("str.app.high", 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textBox(String text, int level) {
    Color color = Colors.black;
    FontWeight fontWeight = FontWeight.normal;
    if (this.levle == level) {
      color = Colors.white;
      fontWeight = FontWeight.bold;
    }
    return GestureDetector(
      onTap: () {
        if (this.levle != level)
          setState(() {
            this.levle = level;
          });
      },
      child: SizedBox(
        width: 50,
        child: Center(
            child: Text(
          text,
          style: CustomTheme.body3.copyWith(color: color, fontWeight: fontWeight),
          textScaleFactor: 1.0,
        )),
      ),
    );
  }
}
