import 'dart:developer';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:elajkom/ui/widgets/app_widgets.dart';
import '../../../classes/models/specialty.dart';
import '../../../classes/models/user.dart';
import '../../../classes/providers/initial_data_provider.dart';
import '../../../util/custome_widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/utility/global_var.dart';
import '../splash_page.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/SignupPage';
  final UserType userType;
  SignupPage([this.userType = UserType.USER]);
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  UserProvider userProvider;
  InitialDataProvider initialDataProvider;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  Size size;

  String _firstName;
  String _lastName;
  // String _displayName;
  String _email;
  String _phoneNumber;
  String _countryPhoneCode = '+90';
  String _password;
  Specialty _specialty;

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    userProvider = Provider.of<UserProvider>(context);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    size = MediaQuery.of(context).size;
    String pageTitle = str.formAndAction.signup;

    if (widget.userType == UserType.DOCTOR) pageTitle += " " + str.app.doctor;
    return Scaffold(
      backgroundColor: CustomTheme.cardBackground,
      appBar: AppBar(title: Text(pageTitle), elevation: 0),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: CustomTheme.standardPadding,
              child: Column(
                children: <Widget>[
                  LogoWidget(),
                  formSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  formSection() {
    return Card(
      child: Padding(
        padding: CustomTheme.standardPadding,
        child: Column(
          children: <Widget>[
            buildTextFieldForm(),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldForm() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          width: size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: str.formAndAction.firstName + " * ",
                      keyboardType: TextInputType.text,
                      validator: (String val) => val.isEmpty || val.length < 3 ? str.msg.invalidName : null,
                      onSaved: (String val) => _firstName = val.trim(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: str.formAndAction.lastName + " * ",
                      keyboardType: TextInputType.text,
                      validator: (String val) => val.isEmpty || val.length < 3 ? str.msg.invalidName : null,
                      onSaved: (String val) => _lastName = val.trim(),
                    ),
                  ),
                ],
              ),
              if (widget.userType == UserType.DOCTOR) SizedBox(height: 15),
              if (widget.userType == UserType.DOCTOR)
                DropdownWidget(
                  initValue: GlobalVar.getFirstListItem(initialDataProvider.specialties),
                  dataList: initialDataProvider.specialties,
                  onChange: (item) => setState(() => _specialty = item),
                  borderShap: true,
                ),
              SizedBox(height: 15),
              Directionality(
                textDirection: TextDirection.ltr,
                child: CustomTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  labelText: str.formAndAction.email,
                  textDirection: TextDirection.ltr,
                  validator: (String val) => GlobalVar.emailValidation(val.trim(), false),
                  onSaved: (String val) => _email = val.trim(),
                ),
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
                      initialSelection: 'tr',
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
                        keyboardType: TextInputType.phone,
                        labelText: str.formAndAction.phone + " * ",
                        validator: (String val) => (val.isEmpty || val.length < 6) ? str.msg.enterPhone : null,
                        onSaved: (String val) => _phoneNumber = val.trim(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Directionality(
                textDirection: TextDirection.ltr,
                child: CustomPasswordTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  labelText: str.formAndAction.password + " * ",
                  validator: (String val) => val.isEmpty || val.length < 5 ? str.msg.passwordShort : null,
                  onSaved: (String val) => _password = val.trim(),
                ),
              ),
              SizedBox(height: 20),
              ButtonWidget(str.formAndAction.signup, _submit, padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(str.formAndAction.alreadyHaveAnAccount),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(str.formAndAction.logIn, style: CustomTheme.TextButtonTextStyle1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignupButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          str.formAndAction.alreadyHaveAnAccount,
          style: TextStyle(fontSize: 14, letterSpacing: 0.5),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Text(
            str.formAndAction.logIn,
            style: CustomTheme.TextButtonTextStyle1.copyWith(
              color: theme.primaryColor,
            ),
          ),
        )
      ],
    );
  }

  void _submit() async {
    if (formKey.currentState.validate()) {
      // if form fields are valid
      formKey.currentState.save();
      setState(() {
        _isLoading = true; // show full progress
      });
      try {
        await userProvider.singup(_firstName, _lastName, _email, _phoneNumber, _countryPhoneCode, _password, DateTime.now().toIso8601String(),
            _specialty?.id, widget.userType == UserType.DOCTOR ? 2 : 1);
        Navigator.of(context).pushNamedAndRemoveUntil(SplashPage.routeName, ModalRoute.withName('/'));
      } catch (err) {
        log(err.toString());
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void loginExternal(String grantType, String accessToken) async {
    setState(() {
      _isLoading = true; // show full progress
    });
    try {
      await userProvider.loginExternalGrandtype(grantType, accessToken);
      Navigator.of(context).pushNamedAndRemoveUntil(SplashPage.routeName, ModalRoute.withName('/'));
    } catch (err) {
      log(err.toString());
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
