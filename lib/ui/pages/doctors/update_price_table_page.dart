import '../../../classes/models/meetingPrices.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

import 'package:provider/provider.dart';
import '../../../classes/providers/user_provider.dart';

class UpdatePriceTablePage extends StatefulWidget {
  static const String routeName = '/UpdatePriceTablePage';
  @override
  _UpdatePriceTablePageState createState() => _UpdatePriceTablePageState();
}

class _UpdatePriceTablePageState extends State<UpdatePriceTablePage> {
  final formKey = GlobalKey<FormState>();
  UserProvider userProvider;
  Size size;
  List<MeetingPrices> meetingPrices = [];

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    if (meetingPrices.length == 0) meetingPrices = List<MeetingPrices>.from(userProvider.user.meetingPrices);

    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.updatePriceInfo),
      ),
      body: SafeArea(
        child: FullScreenLoading(
            inAsyncCall: _isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(FontAwesomeIcons.moneyBill, color: CustomTheme.accentColor, size: 28),
                        SizedBox(width: 15),
                        Text(str.app.priceTable, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    _pricesForm(),
                  ],
                ),
              ),
            )),
      ),
      floatingActionButton: ButtonWidget(str.formAndAction.save, _submit, padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
    );
  }

  Widget _pricesForm() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8, top: 20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _rowsList(),
        ),
      ),
    );
  }

  List<Widget> _rowsList() {
    List<Widget> list = [];

    for (var i = 0; i < meetingPrices.length; i++) {
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            CheckboxListTile(
              title: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(meetingPrices[i].meetingDuration?.durationInMinutes.toString() + " (${str.app.timeUnit})",
                    style: CustomTheme.title2, textAlign: TextAlign.center),
              ),
              value: meetingPrices[i].isActive,
              onChanged: (val) => setState(() => meetingPrices[i].isActive = val),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(str.app.price + " - " + str.app.video, style: CustomTheme.title3, textAlign: TextAlign.center),
                Container(
                  padding: EdgeInsets.all(3),
                  height: 60,
                  width: size.width * 0.6,
                  child: CustomTextFormField(
                    initialValue: GlobalVar.doubleToString(meetingPrices[i].videoPrice),
                    keyboardType: TextInputType.number,
                    enabled: meetingPrices[i].isActive,
                    textStyle: CustomTheme.numberStyle,
                    labelText: "${str.app.video} ${GlobalVar.appCurrency}",
                    validator: (String val) => !meetingPrices[i].isActive
                        ? null
                        : _priceValidation(val, meetingPrices[i].meetingDuration.videoMaxPrice, meetingPrices[i].meetingDuration.videoMinPrice),
                    onChanged: (value) => meetingPrices[i].videoPrice = double.tryParse(value),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(str.app.price + " - " + str.app.voice, style: CustomTheme.title3, textAlign: TextAlign.center),
                Container(
                  padding: EdgeInsets.all(3),
                  height: 60,
                  width: size.width * 0.6,
                  child: CustomTextFormField(
                    initialValue: GlobalVar.doubleToString(meetingPrices[i].audioPrice),
                    keyboardType: TextInputType.number,
                    enabled: meetingPrices[i].isActive,
                    textStyle: CustomTheme.numberStyle,
                    labelText: "${str.app.price} ${GlobalVar.appCurrency}",
                    validator: (String val) => !meetingPrices[i].isActive
                        ? null
                        : _priceValidation(val, meetingPrices[i].meetingDuration.audioMaxPrice, meetingPrices[i].meetingDuration.audioMinPrice),
                    onChanged: (value) => meetingPrices[i].audioPrice = double.tryParse(value),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(str.app.price + " - " + str.app.chat, style: CustomTheme.title3, textAlign: TextAlign.center),
                Container(
                  padding: EdgeInsets.all(3),
                  height: 60,
                  width: size.width * 0.6,
                  child: CustomTextFormField(
                    initialValue: GlobalVar.doubleToString(meetingPrices[i].chatPrice),
                    keyboardType: TextInputType.number,
                    enabled: meetingPrices[i].isActive,
                    textStyle: CustomTheme.numberStyle,
                    labelText: "${str.app.chat} ${GlobalVar.appCurrency}",
                    validator: (String val) => !meetingPrices[i].isActive
                        ? null
                        : _priceValidation(val, meetingPrices[i].meetingDuration.chatMaxPrice, meetingPrices[i].meetingDuration.chatMinPrice),
                    onChanged: (value) => meetingPrices[i].chatPrice = double.tryParse(value),
                  ),
                ),
              ],
            ),
            Divider(thickness: 2),
          ],
        ),
      );
    }
    return list;
  }

  void _submit() async {
    if (formKey.currentState.validate()) {
      // if form fields are valid
      formKey.currentState.save();
      setIsLoading(true);
      try {
        List<Map<String, dynamic>> body = [];
        meetingPrices.forEach((element) {
          body.add({
            "doctorId": element.doctorId,
            "meetingDurationId": element.meetingDurationId,
            "videoPrice": element.videoPrice,
            "audioPrice": element.audioPrice,
            "chatPrice": element.chatPrice,
            "isActive": element.isActive,
          });
        });
        await DoctorServices().updateMeetingPrices(body);
        userProvider.user.meetingPrices = meetingPrices;
        userProvider.notifyListenersFunc();
        Navigator.pop(context);
      } catch (err) {
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setIsLoading(false);
    }
  }

  String _priceValidation(String value, int max, int min) {
    double val = double.tryParse(value);
    if (val == null) return str.msg.fillFieldNumber;
    if (val > max) return str.app.valueMustLessThan + max.toString();
    if (val < min) return str.app.valueMustGreatThan + min.toString();
    return null;
  }

  bool _isLoading = false;
  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }
}
