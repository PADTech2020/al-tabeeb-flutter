import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../ui/pages/account/login.dart';
import '../../../classes/providers/chat_provider.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../ui/widgets/single_chat.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class ChatsPage extends StatefulWidget {
  static const String routeName = '/ChatsPage';
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with AutomaticKeepAliveClientMixin<ChatsPage> {
  @override
  bool get wantKeepAlive => true;

  ChatProvider chatProvider;
  UserProvider userProvider;
  TextEditingController searchController = TextEditingController();
  bool _searchMode = false;
  int page = 0;

  @override
  void initState() {
    log('********************************************************************** ChatsPage.initState');
    Future.microtask(() {
      if (userProvider.isLogin()) chatProvider.initChatHubConnection();
    });

    super.initState();
  }

  @override
  void dispose() async {
    chatProvider.chatPageDispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    chatProvider = Provider.of<ChatProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: CustomTheme.cardBackground,
      child: userProvider.isLogin()
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                headerSection(),
                searchSection(),
                buildChatList(),
              ],
            )
          : noLoginSection(),
    );
  }

  Widget noLoginSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        headerSection(),
        ErrorCustomWidget(
          str.msg.loginFirst,
          icon: Icons.sentiment_dissatisfied,
          color: CustomTheme.accentColor,
          showErrorWord: false,
          action: TextButton(
            child: Text(str.formAndAction.logIn),
            onPressed: () => Navigator.of(context).pushNamed(LoginPage.routeName),
          ),
        ),
      ],
    );
  }

  Widget headerSection() {
    return Padding(
      padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
      child: Text(str.main.chats, style: CustomTheme.title3),
    );
  }

  Widget searchSection() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        color: CustomTheme.greyBackground,
      ),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: str.main.search,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onTap: () => setState(() => _searchMode = true),
              onSubmitted: (value) => search(),
              onChanged: (value) => search(),
            ),
          ),
          _searchMode ? GestureDetector(onTap: resetSearch, child: Icon(Icons.clear, color: Colors.black)) : SizedBox(),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildChatList() {
    return Expanded(
      child: Container(
        color: CustomTheme.mainPageBackground,
        child: ListView.builder(
          itemCount: chatProvider.chats.length + 1,
          itemBuilder: (ctx, index) {
            if (index == chatProvider.chats.length - 10 && chatProvider.messagesMoreAvalible) {
              loadDataList(++page);
            }
            if (index == chatProvider.chats.length) {
              if (chatProvider.chats.length == 0)
                return Opacity(
                  opacity: .5,
                  child: ErrorCustomWidget(str.msg.noMessagesAvailable,
                      icon: FontAwesomeIcons.comments, color: CustomTheme.accentColor, showErrorWord: false),
                );
              else
                return SizedBox();
            }
            return SingleChat(chatProvider.chats[index]);
          },
        ),
        //   child: chatProvider.chats.length > 0
        //       ? ListView.builder(
        //           // separatorBuilder: (context, index) => Divider(thickness: 1, endIndent: 16, indent: 16),
        //           itemBuilder: (context, index) => SingleChat(chatProvider.chats[index]),
        //           itemCount: chatProvider.chats.length,
        //         )
        //       : Opacity(
        //           opacity: .5,
        //           child: ErrorCustomWidget(str.msg.noMessagesAvailable,
        //               icon: FontAwesomeIcons.comments, color: CustomTheme.accentColor, showErrorWord: false)),
      ),
    );
  }

  Future<void> loadDataList(int page) async {
    try {
      if (page == 0) resetSetting();
      chatProvider.getChatsInfo(page);
    } catch (err) {
      print(err.toString());
    }
  }

  void resetSetting() {
    page = 0;
    chatProvider.messages = [];
  }

  void search() async {
    String _searchQuery = searchController.text;
    await Future.delayed(Duration(milliseconds: 200));
    if (_searchQuery == searchController.text) {
      chatProvider.getChatsInfo(0, q: _searchQuery);
      _searchQuery = null;
    }
  }

  void resetSearch() {
    searchController.text = '';
    FocusScope.of(context).unfocus();
    chatProvider.getChatsInfo(0);
    setState(() => _searchMode = false);
  }
}
