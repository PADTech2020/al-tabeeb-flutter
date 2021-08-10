import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../classes/models/nationalities.dart';
import '../../../classes/models/specialty.dart';
import '../../../classes/models/user.dart';
import '../../../classes/providers/initial_data_provider.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/dropdown_widget.dart';
import '../../../util/custome_widgets/image_widgets.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import '../image_picker_page.dart';

class UpdatePersonalInfoPage extends StatefulWidget {
  static const String routeName = '/UpdatePersonalInfoPage';
  @override
  _UpdatePersonalInfoPageState createState() => _UpdatePersonalInfoPageState();
}

class _UpdatePersonalInfoPageState extends State<UpdatePersonalInfoPage> {
  UserProvider userProvider;
  InitialDataProvider initialDataProvider;
  TextEditingController birthdayController = TextEditingController();
  Size size;
  File _imageFile;

  final formKey = GlobalKey<FormState>();
  String _firstNameAr;
  String _firstNameEn;
  String _firstNameTr;
  String _lasttNameAr;
  String _lasttNameEn;
  String _lasttNameTr;
  String _phoneNumber;
  String _countryPhoneCode = '+90';
  String _displayNameAr;
  String _displayNameEn;
  String _displayNameTr;
  Specialty _specialty;
  String _bioAr;
  String _bioEn;
  String _bioTr;

  String _birthday;
  Nationalities _nationalities;
  int _gender;
  String _youTubeVideo;
  int _meetingReminder;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    userProvider = Provider.of<UserProvider>(context);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    initDate();
    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.updatePersonalInfo),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _form(),
              ],
            ),
          ),
        ),
      ),
    );
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [],
                          ),
                        ),
                        _userProfileImage(),
                      ],
                    ),
                    ////////////////{ firstName } ////////////////
                    CustomTextFormField(
                      initialValue: userProvider.user.firstNameAr ?? "",
                      labelText: str.formAndAction.firstName + " " + str.main.arabicTrans,
                      keyboardType: TextInputType.text,
                      validator: (String val) => val.isEmpty || val.length < 3 ? str.msg.invalidName : null,
                      onSaved: (String val) => _firstNameAr = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.firstNameEn ?? "",
                      labelText: str.formAndAction.firstName + " " + str.main.englishTrans,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _firstNameEn = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.firstNameTr ?? "",
                      labelText: str.formAndAction.firstName + " " + str.main.turkishTrans,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _firstNameTr = val.trim(),
                    ),
                    SizedBox(height: 6),
                    Divider(),
                    SizedBox(height: 6),
                    ////////////////{ lastName } ////////////////
                    CustomTextFormField(
                      initialValue: userProvider.user.lastNameAr ?? "",
                      labelText: str.formAndAction.lastName + " " + str.main.arabicTrans,
                      keyboardType: TextInputType.text,
                      validator: (String val) => val.isEmpty || val.length < 3 ? str.msg.invalidName : null,
                      onSaved: (String val) => _lasttNameAr = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.lastNameEn ?? "",
                      labelText: str.formAndAction.lastName + " " + str.main.englishTrans,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _lasttNameEn = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.lastNameTr ?? "",
                      labelText: str.formAndAction.lastName + " " + str.main.turkishTrans,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _lasttNameTr = val.trim(),
                    ),
                    SizedBox(height: 6),
                    Divider(),
                    SizedBox(height: 6),
                    ////////////////{ displayName  } ////////////////
                    CustomTextFormField(
                      initialValue: userProvider.user.displayNameAr ?? '',
                      labelText: str.formAndAction.displayName + " " + str.main.arabicTrans,
                      keyboardType: TextInputType.text,
                      maxLength: 45,
                      onSaved: (String val) => _displayNameAr = val.trim(),
                    ),
                    CustomTextFormField(
                      initialValue: userProvider.user.displayNameEn ?? '',
                      labelText: str.formAndAction.displayName + " " + str.main.englishTrans,
                      keyboardType: TextInputType.text,
                      maxLength: 45,
                      onSaved: (String val) => _displayNameEn = val.trim(),
                    ),
                    CustomTextFormField(
                      initialValue: userProvider.user.displayNameTr ?? '',
                      labelText: str.formAndAction.displayName + " " + str.main.turkishTrans,
                      keyboardType: TextInputType.text,
                      maxLength: 45,
                      onSaved: (String val) => _displayNameTr = val.trim(),
                    ),
                    SizedBox(height: 6),
                    Divider(),
                    SizedBox(height: 6),

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
                            initialSelection: userProvider.user.countryPhoneCode ?? '+90',
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
                          child: CustomTextFormField(
                            initialValue: _phoneNumber ?? "",
                            keyboardType: TextInputType.phone,
                            labelText: str.formAndAction.phone,
                            validator: (String val) => val.isNotEmpty && val.length < 6 ? str.msg.invalidPhone : null,
                            onSaved: (String val) => _phoneNumber = val.trim(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),
                    DropdownWidget(
                      initValue: _specialty,
                      dataList: initialDataProvider.specialties,
                      onChange: (item) => setState(() => _specialty = item),
                      borderShap: true,
                    ),
                    SizedBox(height: 6),
                    Divider(),
                    SizedBox(height: 6),
                    ////////////////{ bio  } ////////////////
                    CustomTextFormField(
                      initialValue: userProvider.user.bioAr ?? '',
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      labelText: str.app.bio + " " + str.main.arabicTrans,
                      onSaved: (String val) => _bioAr = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.bioEn ?? '',
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      labelText: str.app.bio + " " + str.main.englishTrans,
                      onSaved: (String val) => _bioEn = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.bioTr ?? '',
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      labelText: str.app.bio + " " + str.main.turkishTrans,
                      onSaved: (String val) => _bioTr = val.trim(),
                    ),
                    SizedBox(height: 6),
                    Divider(),
                    SizedBox(height: 6),

                    CustomTextFormField(
                      initialValue: userProvider.user.youTubeVideo ?? '',
                      keyboardType: TextInputType.url,
                      labelText: str.app.youTubeVideoUrl,
                      onSaved: (String val) => _youTubeVideo = val.trim(),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(str.app.meetingReminder),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownWidget(
                            dataList: [0, 10, 20, 40],
                            initValue: userProvider.user.meetingReminder ?? 0,
                            onChange: (item) => setState(() => _meetingReminder = item),
                            borderShap: true,
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
                      child: Text(str.formAndAction.changePassword, style: CustomTheme.TextButtonTextStyle1.copyWith(fontSize: 15)),
                      onPressed: changePasswordBuilder,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void initDate() {
    if (_specialty == null)
      _specialty = initialDataProvider.specialties.firstWhere(
        (element) => element.id == userProvider.user.specialtyId,
        orElse: () => GlobalVar.getFirstListItem(initialDataProvider.specialties),
      );
    if (_nationalities == null)
      _nationalities = initialDataProvider.nationalities.firstWhere(
        (element) => element.nationality == userProvider.user.nationality ?? 0,
        orElse: () => GlobalVar.getFirstListItem(initialDataProvider.nationalities),
      );
    if (birthdayController.text.isEmpty) {
      birthdayController.text = GlobalVar.dateForamt(userProvider.user.birthday) ?? '';
      _birthday = userProvider.user.birthday;
    }
    if (_gender == null) _gender = userProvider.user.gender;
    if (_meetingReminder == null) _meetingReminder = userProvider.user.meetingReminder;

    if (_countryPhoneCode == null) _countryPhoneCode = userProvider.user.countryPhoneCode ?? '+90';
    if (_phoneNumber == null || _phoneNumber.isEmpty) if (userProvider.user?.phoneNumber != null && userProvider.user.phoneNumber.isNotEmpty)
      _phoneNumber = _getUserPhoneWithoutcountryCode();
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
        user.firstNameAr = _firstNameAr;
        user.firstNameEn = _firstNameEn;
        user.firstNameTr = _firstNameTr;

        user.lastNameAr = _lasttNameAr;
        user.lastNameEn = _lasttNameEn;
        user.lastNameTr = _lasttNameTr;

        user.displayNameAr = _displayNameAr;
        user.displayNameEn = _displayNameEn;
        user.displayNameTr = _displayNameTr;

        user.countryPhoneCode = _countryPhoneCode;
        user.phoneNumber = _phoneNumber;
        user.specialtyId = _specialty.id;
        user.specialty = _specialty.title;

        user.bioAr = _bioAr;
        user.bioEn = _bioEn;
        user.bioTr = _bioTr;

        user.birthday = _birthday;
        user.nationality = _nationalities.nationality;
        user.nationalityString = _nationalities.nationalityString;
        user.gender = _gender;
        user.youTubeVideo = _youTubeVideo;
        user.meetingReminder = _meetingReminder;
        await userProvider.updateAccount(user.toJson());
        if (_youTubeVideo != null && _youTubeVideo.isNotEmpty) user.youTubeVideoId = YoutubePlayer.convertUrlToId(_youTubeVideo);
        setTranslationParam(user);
        userProvider.user = user;
        Navigator.pop(context);
      } catch (err) {
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setIsLoading(false);
    }
  }

  void setTranslationParam(User user) {
    if (GlobalVar.initializationLanguage == 'ar') {
      user.firstName = user.firstNameAr;
      user.lastName = user.lastNameAr;
      user.displayName = user.displayNameAr;
      user.bio = user.bioAr;
    } else if (GlobalVar.initializationLanguage == 'en') {
      user.firstName = user.firstNameEn;
      user.lastName = user.lastNameEn;
      user.displayName = user.displayNameEn;
      user.bio = user.bioEn;
    } else if (GlobalVar.initializationLanguage == 'tr') {
      user.firstName = user.firstNameTr;
      user.lastName = user.lastNameTr;
      user.displayName = user.displayNameTr;
      user.bio = user.bioTr;
    }

    user.fullName = user.firstName + " " + user.lastName;
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
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      _changePassworsetState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = false;
  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }
}
