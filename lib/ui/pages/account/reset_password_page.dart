import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import 'forget_password_page.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String routeName = '/ResetPasswordStep2';

  final ForgetPasswordMethod method;
  final String value;
  final String code;

  ResetPasswordPage(this.method, this.value, this.code);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  UserProvider userProvider;
  String _code;
  String _password;
  @override
  void initState() {
    if (widget.code != null) _code = widget.code;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(str.formAndAction.resetPassword), elevation: 0),
      body: FullScreenLoading(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: CustomTheme.standardPadding,
            child: Column(
              children: <Widget>[
                Image.asset(GlobalVar.logoLand, height: 60),
                SizedBox(height: 20),
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
          Text(widget.value ?? '', style: CustomTheme.body1),
          SizedBox(height: 20),
          if (widget.code == null)
            CustomTextFormField(
              keyboardType: TextInputType.text,
              labelText: str.formAndAction.code,
              enabled: widget.code == null,
              maxLines: 1,
              initialValue: _code,
              validator: (String val) => val.isEmpty || val.length < 5 ? str.msg.fillField : null,
              onSaved: (String val) => _code = val.trim(),
            ),
          SizedBox(height: 15),
          CustomPasswordTextFormField(
            keyboardType: TextInputType.visiblePassword,
            labelText: str.formAndAction.newPassword,
            validator: (String val) => val.isEmpty || val.length < 5 ? str.msg.passwordShort : null,
            onSaved: (String val) => _password = val.trim(),
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
        await userProvider.resetPassword(widget.method, widget.value, _code, _password);
        Navigator.of(context).popUntil((route) => route.settings.name == '/MainPage');
      } catch (err) {
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setState(() {
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
