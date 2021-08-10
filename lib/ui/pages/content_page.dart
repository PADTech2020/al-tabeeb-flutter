import 'dart:convert';
import 'dart:developer';

import '../../util/custome_widgets/loading.dart';
import '../../util/custome_widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/initial_data_provider.dart';
import 'main_page.dart';

class ContentPage extends StatefulWidget {
  static const String routeName = '/ContentPage';
  final ContentPageType contentType;
  ContentPage(this.contentType);
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  WebViewController _controller;
  InitialDataProvider initialDataProvider;
  ContentPageType contentType;
  String title;
  String url;
  String htmlContent = "";

  @override
  Widget build(BuildContext context) {
    log('%%%%%%%%%%%%%%%%% _ContentPageState build ${widget.contentType}');
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    _initData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title ?? ""),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: SizedBox.expand(
            child: WebView(
              initialUrl: 'about:blank',
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                _loadHtmlFromAssets();
              },
            ),
          ),
        ),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }

  _loadHtmlFromAssets() {
    _controller.loadUrl(Uri.dataFromString(htmlContent ?? "", mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  void _initData() {
    if (widget.contentType != contentType) {
      contentType = widget.contentType;
      switch (widget.contentType) {
        case ContentPageType.PrivacyPolicy:
          url = 'PrivacyPolicy';
          break;
        case ContentPageType.About:
          url = 'About';
          break;
        case ContentPageType.PaymentPolicy:
          url = 'paymentPolicy';
          break;
        default:
          url = 'About';
          break;
      }
      _loadData();
    }
  }

  void _loadData() async {
    setIsLoading(true);
    try {
      var res = await initialDataProvider.getContentPage(url);
      if (res != null) {
        title = res['title'];
        htmlContent = res['body'];
        _loadHtmlFromAssets();
      }
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
