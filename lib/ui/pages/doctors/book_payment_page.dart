import 'package:elajkom/ui/sections/payment_form.dart';
import 'package:elajkom/util/custome_widgets/button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../classes/providers/doctor_services.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class BookPaymentPage extends StatefulWidget {
  static const String routeName = '/MeetingPaymentPage';
  final int bookId;
  BookPaymentPage(this.bookId);
  @override
  _BookPaymentPageState createState() => _BookPaymentPageState();
}

class _BookPaymentPageState extends State<BookPaymentPage> {
  WebViewController _controller;
  String htmlContent = "";
  int stage = 1;
  String paymentApiUrl;
  String successUrl = 'https://al-tabeeb.com/${GlobalVar.initializationLanguage}/Order/Success';
  String failureUrl = 'https://al-tabeeb.com/${GlobalVar.initializationLanguage}/Order/Failure';

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.paymentInfo),
      ),
      body: SafeArea(
        child: stage == 1
            ? firstStage()
            : stage == 2
                ? secondStage()
                : thirdStage(),
      ),
    );
  }

  Widget thirdStage() {
    bool success = stage == 3;
    String text = str.app.paymentFail;
    IconData icon = Icons.sentiment_very_dissatisfied;
    if (success) {
      text = str.app.paymentSucess;
      icon = Icons.check_circle_outline;
    }
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Icon(icon, color: CustomTheme.accentColor, size: 120),
          SizedBox(height: 20),
          Text(text, style: CustomTheme.title2),
          SizedBox(height: 20),
          ButtonWidget(
            str.main.back,
            () {
              Navigator.pop(context, success);
            },
            margin: EdgeInsets.all(25),
          ),
        ],
      ),
    );
  }

  Widget secondStage() {
    return WebView(
      initialUrl: paymentApiUrl ?? 'about:blank',
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
        _loadHtmlFromAssets();
      },
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        if (url.startsWith(successUrl)) {
          setState(() => stage = 3);
        } else if (url.startsWith(failureUrl)) {
          setState(() => stage = 4);
        }
      },
    );
  }

  _loadHtmlFromAssets() {
    _controller.loadUrl(Uri.dataFromString(htmlContent, mimeType: 'text/html').toString());
  }

  Widget firstStage() {
    return FullScreenLoading(
      inAsyncCall: _isLoading,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PaymentFormSection(_sendBTN),
      ),
    );
  }

  void _sendBTN(String nameOnCard, String number, String month, String year, String cvc) async {
    try {
      setIsLoading(true);
      String date = intl.DateFormat('MM/yy').format(DateTime(int.parse(year), int.parse(month)));
      var res = await DoctorServices().payBooking(meetingId: widget.bookId, cvc: cvc, expiry: date, name: nameOnCard, number: number);
      htmlContent = res['htmlContent'];
      setState(() => stage = 2);
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
}
