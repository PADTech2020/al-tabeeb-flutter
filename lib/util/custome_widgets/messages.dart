import 'package:flutter/material.dart';
import '../utility/custom_theme.dart';
import '../../util/utility/global_var.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;

  CustomDialog({this.title, this.message, this.actions});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 25,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: title != null ? Text(title, style: CustomTheme.title3) : null,
      content: message != null && message.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(message, style: CustomTheme.body2),
            )
          : null,
      actions: actions ?? [TextButton(child: Text(str.main.ok), onPressed: () => Navigator.of(context).pop())],
    );
  }
}

class SnackBarWidget {
  static SnackBar blankSnakBar(String text, {String actionLable, Function actionOnTap}) {
    return SnackBar(
      // behavior: SnackBarBehavior.floating,
      content: Text(text ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
      action: actionOnTap != null ? SnackBarAction(label: actionLable ?? "", onPressed: actionOnTap) : null,
    );
  }
}

class ErrorCustomWidget extends StatelessWidget {
  final String errorMsg;
  final IconData icon;
  final Color color;
  final double size;
  final showErrorWord;
  final Widget action;
  ErrorCustomWidget(
    this.errorMsg, {
    this.icon = Icons.sentiment_very_dissatisfied,
    this.color = CustomTheme.accentColor,
    this.size = 80,
    this.showErrorWord = false,
    this.action,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 25),
        Center(child: Icon(icon, color: color.withOpacity(0.5), size: size)),
        showErrorWord
            ? Center(
                child: Padding(
                  padding: CustomTheme.standardPadding,
                  child: Text(
                    '${str.msg.errorOccurred} ',
                    style: CustomTheme.title3.copyWith(color: Colors.black12),
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(height: 15),
        Center(
          child: Padding(
            padding: CustomTheme.standardPadding,
            child: Text(
              ' $errorMsg',
              style: CustomTheme.body1.copyWith(color: Colors.black54),
            ),
          ),
        ),
        action ?? SizedBox(),
      ],
    );
  }
}
