import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function onPress;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double width;
  final Color color;

  const ButtonWidget(this.text, this.onPress, {Key key, this.padding, this.margin, this.width, this.color = CustomTheme.accentColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
        ),
        onPressed: onPress,
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final double dimension;
  final Color color;
  final EdgeInsets padding;
  final double elevation;

  CircularButton({this.child, this.onTap, this.dimension = 35, this.color = Colors.white, this.padding = EdgeInsets.zero, this.elevation = 5});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimension,
      height: dimension,
      child: MaterialButton(
        child: child,
        onPressed: onTap,
        shape: CircleBorder(),
        color: color,
        elevation: elevation,
        padding: padding,
        splashColor: color,
      ),
    );
  }
}

class CircularSendButton extends StatelessWidget {
  final Function ontap;
  final double dimension;
  CircularSendButton(this.ontap, {this.dimension = 43});
  @override
  Widget build(BuildContext context) {
    return CircularButton(
      child: Icon(FontAwesomeIcons.solidPaperPlane, size: 20, color: Colors.white),
      onTap: ontap,
      color: CustomTheme.accentColor,
      dimension: dimension,
    );
  }
}

class ButtonWidgetActive extends StatelessWidget {
  final String text;
  final Widget child;
  final Function onTap;
  final bool active;
  final Color activeColor;
  ButtonWidgetActive({this.child, this.text, this.onTap, this.active = false, this.activeColor = CustomTheme.accentColor});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: EdgeInsetsDirectional.only(end: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(55),
          color: active ? activeColor : Colors.grey.shade200,
        ),
        child: child != null
            ? child
            : Text(text ?? '', style: CustomTheme.body2.copyWith(color: active ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
