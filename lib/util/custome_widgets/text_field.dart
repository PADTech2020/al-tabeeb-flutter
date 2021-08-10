import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utility/custom_theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String initialValue;
  final TextEditingController controller;
  final TextStyle textStyle;
  final TextDirection textDirection;
  final List<TextInputFormatter> inputFormatters;
  final String labelText;
  final String hintText;
  final String prefixText;
  final String suffixText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final bool autofocus;
  final double height;
  final bool enabled;
  final bool readOnly;
  final Function validator;
  final Function onSaved;
  final Function onSubmitted;
  final Function onTap;
  final Function onChanged;

  const CustomTextFormField({
    Key key,
    this.initialValue,
    this.controller,
    this.textStyle = const TextStyle(fontSize: 14),
    this.inputFormatters,
    this.textDirection,
    this.labelText,
    this.hintText,
    this.prefixText,
    this.suffixText,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.autofocus = false,
    this.keyboardType,
    this.height,
    this.enabled,
    this.readOnly = false,
    this.validator,
    this.onSaved,
    this.onSubmitted,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      style: textStyle,
      maxLength: maxLength,
      autofocus: autofocus,
      textDirection: textDirection,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: keyboardType == TextInputType.multiline || minLines != null ? 15 : 5),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[600])),
        focusColor: CustomTheme.accentColor,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[700]),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[700]),
        suffixText: suffixText,
        suffixStyle: TextStyle(color: Colors.red, fontSize: 22),
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        prefixStyle: TextStyle(color: Colors.red, fontSize: 22),
        prefixIcon: prefixIcon,
      ),
      enabled: enabled,
      readOnly: readOnly,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      onChanged: onChanged,
    );
  }
}

class CustomPasswordTextFormField extends StatefulWidget {
  final String initialValue;
  final TextEditingController controller;
  final TextDirection textDirection;
  final String labelText;
  final String hintText;
  final String prefixText;
  final Widget prefixIcon;
  final Function validator;
  final Function onSaved;
  final TextInputType keyboardType;
  final EdgeInsets padding;
  final EdgeInsets margin;

  CustomPasswordTextFormField({
    this.labelText,
    this.hintText,
    this.textDirection,
    this.prefixText,
    this.prefixIcon,
    this.initialValue,
    this.controller,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  _CustomPasswordTextFormFieldState createState() => _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState extends State<CustomPasswordTextFormField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      textDirection: widget.textDirection,
      obscureText: _obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[600])),
        labelStyle: TextStyle(color: Colors.grey[700]),
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixText: widget.prefixText,
        prefixStyle: TextStyle(color: Colors.red, fontSize: 22),
        prefixIcon: widget.prefixIcon,
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 12.0, start: 12),
          child: GestureDetector(
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
