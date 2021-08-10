import 'dart:developer';

import 'package:elajkom/util/custome_widgets/button.dart';
import 'package:elajkom/util/custome_widgets/text_field.dart';
import 'package:elajkom/util/utility/custom_theme.dart';
import 'package:elajkom/util/utility/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentFormSection extends StatefulWidget {
  final Function(String nameOnCard, String number, String month, String year, String cvc) onSend;
  PaymentFormSection(this.onSend);
  @override
  _PaymentFormSectionState createState() => _PaymentFormSectionState();
}

class _PaymentFormSectionState extends State<PaymentFormSection> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String nameOnCard, month, year, cvc, number;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: str.app.nameOnCard,
                        initialValue: nameOnCard,
                        validator: (String value) => value.isEmpty ? str.msg.fillField : null,
                        onChanged: (String value) => nameOnCard = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: CustomTextFormField(
                          labelText: str.app.creditCardNumber,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(19),
                            CardNumberInputFormatter(),
                          ],
                          initialValue: number,
                          keyboardType: TextInputType.number,
                          validator: (String value) => value.isEmpty || (int.tryParse(getCleanedNumber(value)) == null) ? str.msg.fillFieldInt : null,
                          onChanged: (String value) => number = getCleanedNumber(value),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                        labelText: str.app.cardCode,
                        initialValue: cvc,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (String value) => value.isEmpty || (int.tryParse(value) == null) ? str.msg.fillFieldInt : null,
                        onChanged: (String value) => cvc = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(str.app.cardExpireDate, style: CustomTheme.caption),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: str.app.month,
                        initialValue: month,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(2),
                          CardMonthInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        validator: (String value) => value.isEmpty || (int.tryParse(value) == null) ? str.msg.fillFieldInt : null,
                        onChanged: (String value) => month = value,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: str.app.year,
                        initialValue: year,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        keyboardType: TextInputType.number,
                        validator: (String value) => value.isEmpty || (int.tryParse(value) == null) ? str.msg.fillFieldInt : null,
                        onChanged: (String value) => year = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(child: Image.asset(GlobalVar.assetsImageBase + 'credit_cards.png')),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  child: ButtonWidget(str.app.purchase, _sendBTN),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendBTN() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.onSend(nameOnCard, number, month, year, cvc);
    }
  }

  String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    log('getCleanerNumber : ${text.replaceAll(regExp, '')}');
    return text.replaceAll(regExp, '');
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: new TextSelection.collapsed(offset: string.length));
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    int month = int.tryParse(newText);
    if (month != null && month > 12) newText = oldValue.text;
    return newValue.copyWith(text: newText, selection: new TextSelection.collapsed(offset: newText.length));
  }
}
