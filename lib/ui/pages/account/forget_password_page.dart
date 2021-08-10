import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/pages/account/reset_password_page.dart';

import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/global_var.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';

enum ForgetPasswordMethod { Email, Phone }

class ForgetPasswrodPage extends StatefulWidget {
  static const String routeName = '/ForgetPasswrodPage';
  @override
  _ForgetPasswrodPageState createState() => _ForgetPasswrodPageState();
}

class _ForgetPasswrodPageState extends State<ForgetPasswrodPage> {
  Size size;

  UserProvider userProvider;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  String _value = '';
  ForgetPasswordMethod method;

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomTheme.cardBackground,
      appBar: AppBar(title: Text(str.formAndAction.resetPassword), elevation: 0),
      body: FullScreenLoading(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: CustomTheme.standardPadding,
            child: Column(
              children: <Widget>[
                Image.asset(GlobalVar.logoLand, height: 60),
                SizedBox(height: 35),
                Center(child: formSection()),
              ],
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
          CustomTextFormField(
            initialValue: _value,
            keyboardType: TextInputType.emailAddress,
            labelText: str.formAndAction.email,
            autofocus: true,
            validator: (String val) => _validation(val.trim()),
            onSaved: (String val) => _value = val.trim(),
          ),
          SizedBox(height: 25),
          SizedBox(width: double.infinity, child: ButtonWidget(str.formAndAction.send, _submit)),
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
        if (method == ForgetPasswordMethod.Email) {
          await userProvider.forgetPassword(_value);
          await showDialog(builder: (context) => CustomDialog(message: str.msg.activationCodeSendToEmail), context: context);
          Navigator.pop(context);
        } else if (method == ForgetPasswordMethod.Phone) {
          if (_value.startsWith('00')) {
            _value = '+' + _value.substring(2);
          }
          await userProvider.forgetPasswordPhone(_value);
          Navigator.of(context).pushNamed(ResetPasswordPage.routeName, arguments: [method, _value, null]);
        }
      } catch (err) {
        log(err.toString());
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _validation(String val) {
    if (val.isEmpty) return str.msg.fillField;

    if (RegExp(GlobalVar.emailRegExp).hasMatch(val)) {
      method = ForgetPasswordMethod.Email;
      return null;
    }

    return str.msg.invalidEmail;
  }
}
