import 'package:flutter/material.dart';
import '../utility/custom_theme.dart';

class DropdownWidget extends StatefulWidget {
  final List<dynamic> dataList;
  final Function(dynamic item) onChange;
  final Function(dynamic item) itemToString;
  final dynamic initValue;
  final String hint;
  final bool isExpanded;
  final TextStyle textStyle;
  final double itemHeight;
  final Widget underline;
  final bool buttonShape;
  final Color buttonShapeColor;
  final double borderRadius;
  final double elevation;

  final bool borderShap;
  final Color borderColor;

  DropdownWidget({
    @required this.dataList,
    @required this.onChange,
    this.itemToString,
    this.initValue,
    this.hint,
    this.isExpanded = true,
    this.textStyle = const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    this.itemHeight,
    this.underline,
    this.buttonShape = false,
    this.buttonShapeColor = CustomTheme.accentColor,
    this.borderRadius = 5,
    this.elevation = 1,
    this.borderShap = false,
    this.borderColor = Colors.grey,
  });

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  dynamic value;
  dynamic tempInitValue;

  @override
  void initState() {
    tempInitValue = widget.initValue;
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tempInitValue != widget.initValue) {
      tempInitValue = widget.initValue;
      value = widget.initValue;
    }
    if (widget.dataList.indexOf(value) < 0) value = null;
    if (widget.buttonShape)
      return _btnShape(_buildDropdownButton());
    else if (widget.borderShap)
      return _borderShape(_buildDropdownButton());
    else
      return _buildDropdownButton();
  }

  Widget _buildDropdownButton() {
    return DropdownButton<dynamic>(
      hint: Text(widget.hint ?? '', style: widget.textStyle),
      itemHeight: widget.itemHeight,
      underline: widget.buttonShape ? SizedBox() : widget.underline,
      isExpanded: widget.isExpanded,
      value: value,
      items: widget.dataList
          .map(
            (e) => DropdownMenuItem<dynamic>(child: _singleItem(e), value: e),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          this.value = value;
          widget.onChange(value);
        });
      },
    );
  }

  Widget _singleItem(dynamic item) {
    return Container(
      alignment: Alignment.center,
      height: widget.itemHeight,
      // decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      child: Text(widget.itemToString == null ? item.toString() ?? '' : widget.itemToString(item), style: widget.textStyle),
    );
  }

  Widget _borderShape(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor),
      ),
      child: child,
    );
  }

  Widget _btnShape(Widget child) {
    return Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      shadowColor: widget.buttonShapeColor.withOpacity(.6),
      color: widget.buttonShapeColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: child,
      ),
    );
  }
}
