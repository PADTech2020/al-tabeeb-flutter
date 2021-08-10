import '../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as datePicker;

class DatePickerWidget extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color selectedDateStyleColor;
  final Color selectedSingleDateDecorationColor;
  final BoxShape selectedDayShape;
  final double width;
  final Function(DateTime value) onChange;
  final Function(DateTime value) isDayActive;
  final Function(DateTime value) dayDecorationBuilder;

  DatePickerWidget(
    this.selectedDate,
    this.firstDate,
    this.lastDate, {
    this.onChange,
    this.isDayActive,
    this.dayDecorationBuilder,
    this.selectedDateStyleColor = Colors.white,
    this.selectedDayShape = BoxShape.rectangle,
    this.selectedSingleDateDecorationColor = CustomTheme.accentColor,
    this.width,
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _firstDate;
  DateTime _lastDate;

  @override
  void initState() {
    _firstDate = DateTime(widget.firstDate.year, widget.firstDate.month, widget.firstDate.day);
    _lastDate = DateTime(widget.lastDate.year, widget.lastDate.month, widget.lastDate.day, 24, 59, 59);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildWeekDatePicker();
  }

  buildWeekDatePicker() {
    datePicker.DatePickerStyles styles = datePicker.DatePickerRangeStyles(
        selectedDateStyle: Theme.of(context).accentTextTheme.bodyText1.copyWith(color: widget.selectedDateStyleColor),
        selectedSingleDateDecoration: BoxDecoration(color: widget.selectedSingleDateDecorationColor, shape: widget.selectedDayShape));

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: CustomTheme.cardBackground,
        boxShadow: CustomTheme.boxShadow,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: EdgeInsets.all(2),
      child: datePicker.DayPicker.single(
        selectedDate: widget.selectedDate ?? DateTime.now(),
        onChanged: widget.onChange,
        firstDate: _firstDate,
        lastDate: _lastDate,
        datePickerStyles: styles,
        datePickerLayoutSettings: datePicker.DatePickerLayoutSettings(maxDayPickerRowCount: 5, showPrevMonthEnd: true, showNextMonthStart: true),
        selectableDayPredicate: widget.isDayActive,
        eventDecorationBuilder: widget.dayDecorationBuilder,
      ),
    );
  }

  datePicker.EventDecoration dayDecorationBuilderExample(DateTime date) {
    BoxDecoration roundedBorder = BoxDecoration(
        border: Border.all(
          color: Colors.deepOrange,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));

    return date.day == 21 ? datePicker.EventDecoration(boxDecoration: roundedBorder) : null;
  }
}
