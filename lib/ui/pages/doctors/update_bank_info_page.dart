import '../../../classes/models/user.dart';
import '../../../classes/providers/initial_data_provider.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class UpdateBankInfoPage extends StatefulWidget {
  static const String routeName = '/UpdateBankInfoPage';
  @override
  _UpdateBankInfoPageState createState() => _UpdateBankInfoPageState();
}

class _UpdateBankInfoPageState extends State<UpdateBankInfoPage> {
  UserProvider userProvider;
  InitialDataProvider initialDataProvider;
  Size size;

  final formKey = GlobalKey<FormState>();
  String _passportFirstName;
  String _passportLastName;
  String _nameOnCard;
  String _bankName;
  String _ibanTl;
  String _ibanUsd;

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
        title: Text(str.app.updateBankInfo),
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
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.passportFirstName ?? '',
                      labelText: str.app.passportFirstName,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _passportFirstName = val.trim(),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      initialValue: userProvider.user.passportLastName ?? '',
                      labelText: str.app.passportLastName,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _passportLastName = val.trim(),
                    ),
                    SizedBox(height: 15),
                    Text(str.app.bankInformation, style: CustomTheme.title2),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      initialValue: userProvider.user.nameOnCard ?? '',
                      labelText: str.app.nameOnCard,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _nameOnCard = val.trim(),
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      initialValue: userProvider.user.bankName ?? '',
                      labelText: str.app.bankName,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _bankName = val.trim(),
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      initialValue: userProvider.user.ibanTl ?? '',
                      labelText: str.app.turkIban,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _ibanTl = val.trim(),
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      initialValue: userProvider.user.ibanUsd ?? '',
                      labelText: str.app.dollarIban,
                      keyboardType: TextInputType.text,
                      onSaved: (String val) => _ibanUsd = val.trim(),
                    ),
                    SizedBox(height: 15),
                    SizedBox(height: 25),
                    ButtonWidget(
                      str.formAndAction.save,
                      _submit,
                      padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void initDate() {}

  void _submit() async {
    if (formKey.currentState.validate()) {
      // if form fields are valid
      formKey.currentState.save();
      setIsLoading(true);
      try {
        User user = userProvider.user;
        user.passportFirstName = _passportFirstName;
        user.passportLastName = _passportLastName;
        user.nameOnCard = _nameOnCard;
        user.bankName = _bankName;
        user.ibanTl = _ibanTl;
        user.ibanUsd = _ibanUsd;
        await userProvider.updateAccount(user.toJson());
        userProvider.user = user;
        Navigator.pop(context);
      } catch (err) {
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
      setIsLoading(false);
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
