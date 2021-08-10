import 'package:flutter/material.dart';
import '../utility/custom_theme.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final int value;
  final Color color;
  final double right;
  final double top;

  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
    this.right = 5,
    this.top = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        value > 0
            ? PositionedDirectional(
                start: right,
                top: top,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(135), color: color != null ? color : CustomTheme.accentColor, shape: BoxShape.rectangle),
                  child:
                      Text(value.toString(), style: CustomTheme.numberStyle.copyWith(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
