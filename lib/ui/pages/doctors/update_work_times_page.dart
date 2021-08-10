import 'dart:developer';

import '../../../classes/models/availabilityPlans.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/dropdown_widget.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class UpdateWorkeTimePage extends StatefulWidget {
  static const String routeName = '/UpdateWorkeTimePage';
  @override
  _UpdateWorkeTimePageState createState() => _UpdateWorkeTimePageState();
}

class _UpdateWorkeTimePageState extends State<UpdateWorkeTimePage> {
  final formKey = GlobalKey<FormState>();
  UserProvider userProvider;
  Size size;
  List<AvailabilityPlans> availabilityPlans = [];
  List<DateTime> fromTimeList = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    if (availabilityPlans.length == 0) availabilityPlans = List<AvailabilityPlans>.from(userProvider.user.availabilityPlans);
    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.updatePriceInfo),
      ),
      body: SafeArea(
        child: FullScreenLoading(
            inAsyncCall: _isLoading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(FontAwesomeIcons.clock, color: CustomTheme.accentColor, size: 28),
                        SizedBox(width: 10),
                        Text(str.app.workTimes, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _form(),
                ],
              ),
            )),
      ),
      floatingActionButton: ButtonWidget(str.formAndAction.save, _submit, padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
    );
  }

  Widget _form() {
    List<Widget> rowList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(str.app.day, style: CustomTheme.title2, textAlign: TextAlign.center),
          Text(str.app.fromHour, style: CustomTheme.title2, textAlign: TextAlign.center),
          Text(str.app.toHour, style: CustomTheme.title2, textAlign: TextAlign.center),
        ],
      )
    ];
    for (var i = 0; i < availabilityPlans.length; i++) {
      List<DateTime> toTimeList = [];
      int toTimeStart = availabilityPlans[i].fromHour;
      if (toTimeStart > availabilityPlans[i].toHour) toTimeStart = availabilityPlans[i].toHour;
      log('toTimeStart :$toTimeStart  ');
      for (var h = toTimeStart + 1; h < 25; h++) {
        toTimeList.add(DateTime(0, 0, 0, h));
      }
      rowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => availabilityPlans[i].isActive = !availabilityPlans[i].isActive),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Checkbox(value: availabilityPlans[i].isActive, onChanged: (val) => setState(() => availabilityPlans[i].isActive = val)),
                      FittedBox(child: Text(availabilityPlans[i].dayOfWeekString, style: CustomTheme.title3, textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: DropdownWidget(
                initValue: availabilityPlans[i].isActive ? DateTime(0, 0, 0, availabilityPlans[i].fromHour) : null,
                dataList: availabilityPlans[i].isActive ? fromTimeList : [],
                onChange: (item) => setState(() {
                  availabilityPlans[i].fromHour = item.hour;
                  availabilityPlans[i].fromHourString = GlobalVar.dateForamt(item, 'jm');
                  log('availabilityPlans[i].fromHourString ${availabilityPlans[i].fromHour}');
                }),
                itemToString: (item) => GlobalVar.dateForamt(item, 'jm'),
              ),
            ),
            Expanded(
              child: DropdownWidget(
                initValue: availabilityPlans[i].isActive ? DateTime(0, 0, 0, availabilityPlans[i].toHour) : null,
                dataList: availabilityPlans[i].isActive ? toTimeList : [],
                onChange: (item) => setState(() {
                  availabilityPlans[i].toHour = item.hour;
                  availabilityPlans[i].toHourString = GlobalVar.dateForamt(item, 'jm');
                }),
                itemToString: (item) => GlobalVar.dateForamt(item, 'jm'),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: rowList,
      ),
    );
  }

  void _submit() async {
    setIsLoading(true);
    try {
      List<Map<String, dynamic>> body = [];
      availabilityPlans.forEach((element) {
        body.add({
          "id": 0,
          "doctorId": element.doctorId,
          "dayOfWeek": element.dayOfWeek,
          "fromHour": element.fromHour,
          "fromHourString": element.fromHourString,
          "toHour": element.toHour,
          "toHourString": element.toHourString,
          "isActive": element.isActive
        });
      });
      await DoctorServices().updateAvailabilityPlans(body);
      userProvider.user.availabilityPlans = availabilityPlans;
      userProvider.notifyListenersFunc();
      Navigator.pop(context);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

  bool _isLoading = false;
  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }

  void initData() {
    for (var i = 1; i < 25; i++) {
      fromTimeList.add(DateTime(0, 0, 0, i));
    }
  }
}
