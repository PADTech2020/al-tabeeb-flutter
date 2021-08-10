import 'dart:developer';

import 'package:elajkom/util/custome_widgets/local_notification.dart';

import '../../classes/providers/chat_provider.dart';
import '../../classes/providers/notification_provider.dart';
import '../../classes/services/cloud_messaging.dart';
import 'package:uni_links/uni_links.dart';
import '../../classes/providers/user_provider.dart';
import '../../classes/services/deep_link.dart';
import '../../ui/pages/home_page.dart';
import '../../ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/MainPage';
  static UserProvider userProvider;
  static HomeDrawer homeDrawer;

  final Widget initHomeBody;
  MainPage(this.initHomeBody);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _homeBody = HomePage();
  // String _appbarTitle = "HomePage";

  @override
  void initState() {
    if (widget.initHomeBody != null) _homeBody = widget.initHomeBody;
    MainPage.homeDrawer = HomeDrawer(drawerHandler);
    deepLinkInitPlatformStateForStringUniLinks();
    GlobalVar.cloudMessaging = CloudMessaging(context: context);
    GlobalVar.localNotification = LocalNotification(context);

    Future.microtask(() {
      if (MainPage.userProvider.isLogin()) {
        notificationHubConnection();
        chatHubConnection();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    MainPage.userProvider = Provider.of<UserProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => DeepLink.uriParse(context));
    return WillPopScope(
      onWillPop: () {
        if (_homeBody is! HomePage) {
          drawerHandler(HomePage(), str.main.home);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: _homeBody,
      ),
    );
  }

  void drawerHandler(Widget page, String appbarTitle) {
    setState(() {
      _homeBody = page;
      // _appbarTitle = appbarTitle;
    });
  }

  void chatHubConnection() {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.localUserId = MainPage.userProvider.user.id;
    chatProvider.initChatHubConnection();
  }

  void notificationHubConnection() {
    NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.initNotificationConnection();
  }

  /// DeepLink implementation using a [String] link
  Future<void> deepLinkInitPlatformStateForStringUniLinks() async {
    log('*************************** deepLinkInitPlatformStateForStringUniLinks :');
    String _initialLink;
    Uri _initialUri;
    // Attach a listener to the links stream
    getLinksStream().listen((String link) {
      if (!mounted) return;
      deepKinkUri = null;
      try {
        if (link != null) {
          setState(() {
            deepKinkUri = Uri.parse(link);
          });
        }
      } on FormatException {}
    }, onError: (Object err) {
      if (!mounted) return;
      deepKinkUri = null;
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      print('initial link: $_initialLink');
      if (_initialLink != null) _initialUri = Uri.parse(_initialLink);
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      _initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      _initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      deepKinkUri = _initialUri;
    });
  }
}
