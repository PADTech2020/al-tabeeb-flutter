import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:elajkom/classes/models/nationalities.dart';
import 'package:elajkom/util/custome_widgets/dropdown_widget.dart';
import 'package:elajkom/util/custome_widgets/image_widgets.dart';
import 'package:elajkom/util/utility/custom_theme.dart';
import '../../../classes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/api_provider.dart';

import '../../../classes/providers/initial_data_provider.dart';
import '../../../util/custome_widgets/loading.dart';

import '../../../classes/providers/user_provider.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import '../image_picker_page.dart';

class MyProfile extends StatefulWidget {
  static const String routeName = '/UpdateProfile';
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserProvider userProvider;
  InitialDataProvider initialDataProvider;
  TextEditingController birthdayController = TextEditingController();
  Size size;
  bool _isLoading = false;
  File _imageFile;

  final formKey = GlobalKey<FormState>();
  String _firstName;
  String _lasttName;
  String _phoneNumber;
  String _countryPhoneCode;
  String _displayName;
  int _meetingReminder;

  String _bio;
  String _birthday;
  Nationalities _nationalities;
  int _gender;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    size = MediaQuery.of(context).size;
    userProvider = Provider.of<UserProvider>(context);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    if (GlobalVar.isLogin(context, showAlertDialog: false)) {
      initDate();
      return FullScreenLoading(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _userProfileImage(),
              _form(),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }

  Widget _userProfileImage() {
    double dimn = 125;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          _imageFile != null
              ? ImageView(_imageFile, width: dimn, height: dimn)
              : userProvider.user.profilePhoto == null
                  ? Image.asset(GlobalVar.person, width: dimn, height: dimn)
                  : ImageView(userProvider.user.profilePhoto, width: dimn, height: dimn),
          // userProvider.user.isOnline ? PositionedDirectional(bottom: 5, start: 5, child: CircleColoredWidget()) : SizedBox(),
          Positioned(
            right: 0,
            child: CircleAvatar(
                backgroundColor: CustomTheme.primaryColor.withAlpha(150),
                radius: 15,
                child: InkWell(
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, ImagePickerPage.routeName);
                      if (result is File)
                        setState(() {
                          _imageFile = result;
                        });
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ))),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return userProvider.user == null
        ? SizedBox()
        : Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            initialValue: userProvider.user.firstName,
                            labelText: str.formAndAction.firstName,
                            keyboardType: TextInputType.text,
                            onSaved: (String val) => _firstName = val.trim(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextFormField(
                            initialValue: userProvider.user.lastName,
                            labelText: str.formAndAction.lastName,
                            keyboardType: TextInputType.text,
                            validator: (String val) => val.isEmpty || val.length < 3 ? str.msg.invalidName : null,
                            onSaved: (String val) => _lasttName = val.trim(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.displayName ?? '',
                      labelText: str.formAndAction.displayName,
                      keyboardType: TextInputType.text,
                      maxLength: 45,
                      onSaved: (String val) => _displayName = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.bio ?? '',
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      labelText: str.app.bio,
                      onSaved: (String val) => _bio = val.trim(),
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(4)),
                          child: CountryCodePicker(
                            flagWidth: 25,
                            onChanged: (code) {
                              _countryPhoneCode = code.dialCode;
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: _countryPhoneCode ?? "+90",
                            favorite: ['tr', 'sy', '+966', 'uae', 'kw', 'eg'].toList(),
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: true,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: CustomTextFormField(
                              initialValue: _phoneNumber ?? "",
                              keyboardType: TextInputType.phone,
                              labelText: str.formAndAction.phone,
                              validator: (String val) => val.isNotEmpty && val.length < 6 ? str.msg.invalidPhone : null,
                              onSaved: (String val) => _phoneNumber = val.trim(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Center(child: Text(str.app.gender))),
                        Expanded(
                          flex: 2,
                          child: DropdownWidget(
                            initValue: _gender == 1 ? str.app.female : str.app.male,
                            dataList: [str.app.male, str.app.female],
                            onChange: (item) => setState(() => _gender = item == str.app.female ? 1 : 0),
                            borderShap: true,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Center(child: Text(str.app.birthday))),
                        Expanded(
                          flex: 2,
                          child: CustomTextFormField(
                            controller: birthdayController,
                            labelText: str.app.birthday,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            suffixIcon: InkWell(
                              child: Icon(Icons.calendar_today),
                              onTap: () async {
                                DateTime selectedDate = DateTime.tryParse(_birthday) ?? DateTime(1980);
                                final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2510),
                                );
                                if (picked != null) {
                                  _birthday = picked.toIso8601String();
                                  setState(() => birthdayController.text = GlobalVar.dateForamt(_birthday));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Center(child: Text(str.app.nationality))),
                        Expanded(
                          flex: 2,
                          child: DropdownWidget(
                            initValue: _nationalities,
                            dataList: initialDataProvider.nationalities,
                            onChange: (item) => setState(() => _nationalities = item),
                            borderShap: true,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(str.app.meetingReminder),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownWidget(
                            dataList: [0, 10, 20, 40],
                            initValue: userProvider.user.meetingReminder,
                            borderShap: true,
                            onChange: (item) => setState(() => _meetingReminder = item),
                            itemToString: (item) => userProvider.getMeetingReminderString(item),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    ButtonWidget(
                      str.formAndAction.save,
                      _submit,
                      padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                      width: double.infinity,
                    ),
                    TextButton(
                      child: Text(str.formAndAction.changePassword),
                      onPressed: changePasswordBuilder,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void _submit() async {
    if (formKey.currentState.validate()) {
      // if form fields are valid
      formKey.currentState.save();
      setIsLoading(true);
      try {
        if (_imageFile != null) {
          var imageName = await ApiProvider().uploadFiles(_imageFile);
          userProvider.user.profilePhoto = imageName;
        }
        User user = userProvider.user;
        user.firstName = _firstName;
        user.firstNameAr = _firstName;
        user.firstNameEn = _firstName;
        user.firstNameTr = _firstName;

        user.lastName = _lasttName;
        user.lastNameAr = _lasttName;
        user.lastNameEn = _lasttName;
        user.lastNameTr = _lasttName;

        user.displayName = _displayName;
        user.displayNameAr = _displayName;
        user.displayNameEn = _displayName;
        user.displayNameTr = _displayName;

        user.bio = _bio;
        user.bioAr = _bio;
        user.bioEn = _bio;
        user.bioTr = _bio;

        user.gender = _gender;
        user.birthday = _birthday;
        user.countryPhoneCode = _countryPhoneCode;
        user.phoneNumber = _phoneNumber;
        user.nationality = _nationalities.nationality;
        user.nationalityString = _nationalities.nationalityString;
        user.meetingReminder = _meetingReminder;

        await userProvider.updateAccount(user.toJson());
        userProvider.user = user;
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.msg.updateSucceeded));
      } catch (err) {
        log(err.toString());
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setIsLoading(false);
    }
  }

  void initDate() {
    if (_meetingReminder == null) _meetingReminder = userProvider.user?.meetingReminder ?? 0;
    if (_gender == null) _gender = userProvider.user.gender;
    if (_countryPhoneCode == null) _countryPhoneCode = userProvider.user.countryPhoneCode ?? '+90';
    if (_phoneNumber == null || _phoneNumber.isEmpty) if (userProvider.user?.phoneNumber != null && userProvider.user.phoneNumber.isNotEmpty)
      _phoneNumber = _getUserPhoneWithoutcountryCode();

    if (birthdayController.text.isEmpty) {
      birthdayController.text = GlobalVar.dateForamt(userProvider.user.birthday) ?? '';
      _birthday = userProvider.user.birthday;
    }
    if (_nationalities == null)
      _nationalities = initialDataProvider.nationalities.firstWhere(
        (element) => element.nationality == userProvider.user.nationality ?? 0,
        orElse: () => GlobalVar.getFirstListItem(initialDataProvider.nationalities),
      );
  }

  String _getUserPhoneWithoutcountryCode() {
    String phone = "";
    if (userProvider.user?.phoneNumber != null && userProvider.user.phoneNumber.isNotEmpty) {
      phone = userProvider.user.phoneNumber;
      if (userProvider.user.countryPhoneCode != null &&
          userProvider.user.countryPhoneCode.isNotEmpty &&
          userProvider.user.phoneNumber.startsWith(userProvider.user.countryPhoneCode))
        phone = userProvider.user.phoneNumber.substring(userProvider.user.countryPhoneCode.length);
    }
    return phone;
  }

  final GlobalKey<FormState> _passwordFormKey = GlobalKey();
  String _oldPassword = "";
  String _newPassword = "";
  final _newPasswordController = TextEditingController();
  StateSetter _changePassworsetState;

  void changePasswordBuilder() async {
    await showDialog(
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          _changePassworsetState = setState;
          return SimpleDialog(
            elevation: 25,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: EdgeInsets.all(10),
            title: Text(str.formAndAction.changePassword, textAlign: TextAlign.center),
            children: <Widget>[
              Form(
                key: _passwordFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      userProvider.user.hasPassword
                          ? CustomPasswordTextFormField(
                              initialValue: '',
                              labelText: str.formAndAction.oldPassword,
                              validator: (String val) => val.isEmpty || val.length < 5 ? str.msg.passwordShort : null,
                              onSaved: (value) => _oldPassword = value,
                            )
                          : SizedBox(),
                      SizedBox(height: 15),
                      CustomPasswordTextFormField(
                        controller: _newPasswordController,
                        labelText: str.formAndAction.newPassword,
                        validator: (String val) => val.isEmpty || val.length < 5 ? str.msg.passwordShort : null,
                        onSaved: (value) => _newPassword = value,
                      ),
                      SizedBox(height: 15),
                      CustomPasswordTextFormField(
                        labelText: str.formAndAction.confirmPassword,
                        validator: (String val) => val != _newPasswordController.text ? str.msg.confirmPasswordIncorrect : null,
                      ),
                      SizedBox(height: 20),
                      _isLoading == true
                          ? Center(child: CircularProgressIndicator())
                          : ButtonWidget(str.formAndAction.save, _passwordSubmit, padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12)),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
      context: context,
    );
    _newPasswordController.clear();
  }

  void _passwordSubmit() async {
    if (_passwordFormKey.currentState.validate()) {
      _passwordFormKey.currentState.save();
      _changePassworsetState(() {
        _isLoading = true;
      });
      try {
        if (userProvider.user.hasPassword)
          await userProvider.updateUserPassword(_oldPassword, _newPassword, _newPassword);
        else
          await userProvider.setUserPassword(_newPassword, _newPassword);
        Navigator.pop(context);
      } catch (err) {
        log(err.toString());
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      _changePassworsetState(() {
        _isLoading = false;
      });
    }
  }

  void setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }
}
