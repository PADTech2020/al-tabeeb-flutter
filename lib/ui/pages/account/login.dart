import 'dart:developer';
import 'package:elajkom/ui/widgets/app_widgets.dart';

import '../../../classes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/global_var.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../splash_page.dart';
import 'forget_password_page.dart';
import 'singup_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserProvider userProvider;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: CustomTheme.cardBackground,
      appBar: AppBar(title: Text(str.formAndAction.logIn)),
      body: FullScreenLoading(
        inAsyncCall: _isLoading,
        child: SafeArea(
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
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Directionality(
            textDirection: TextDirection.ltr,
            child: CustomTextFormField(
              keyboardType: TextInputType.emailAddress,
              labelText: str.formAndAction.emailOrPhone,
              // initialValue: 'user@elajkom.kuarkz.com',
              textDirection: TextDirection.ltr,
              validator: (String val) => GlobalVar.emailValidation(val.trim(), true),
              onSaved: (String val) => _email = val.trim(),
            ),
          ),
          SizedBox(height: 15),
          Directionality(
            textDirection: TextDirection.ltr,
            child: CustomPasswordTextFormField(
              keyboardType: TextInputType.visiblePassword,
              labelText: str.formAndAction.password,
              // initialValue: 'P@ssw0rd',
              textDirection: TextDirection.ltr,
              validator: (String val) => val.isEmpty || val.length < 5 ? str.msg.passwordShort : null,
              onSaved: (String val) => _password = val.trim(),
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(ForgetPasswrodPage.routeName),
              child: Text(str.formAndAction.forgetPassword,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  )),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(width: double.infinity, child: ButtonWidget(str.formAndAction.logIn, _submit)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                str.formAndAction.registerMsg,
                style: CustomTheme.body1,
              ),
              SizedBox(width: 25),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(SignupPage.routeName),
                    child: Text(str.formAndAction.signup + " " + str.formAndAction.user, style: CustomTheme.TextButtonTextStyle1),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(SignupPage.routeName, arguments: UserType.DOCTOR),
                    child: Text(str.formAndAction.signup + " " + str.app.doctor, style: CustomTheme.TextButtonTextStyle1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
        await userProvider.login(_email, _password);
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
