
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/nav_bar/custom_bottom_nav_bar.dart';
import 'package:social_geek/components/nav_bar/tab_item.dart';
import 'package:social_geek/services/notification/notification_handler.dart';
import 'package:social_geek/view_models/all_users_view_model.dart';
import 'package:social_geek/views/app/blog_page.dart';
import 'package:social_geek/views/app/my_chat_page.dart';
import 'file:///C:/flutter_uygulamalar/social_geek/lib/views/app/profile/profile_page.dart';
import 'package:social_geek/views/app/users_page.dart';

class HomePage extends StatefulWidget {
  final String id;
  HomePage({this.id});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TabItem _currentTab = TabItem.Users;
  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Users: ChangeNotifierProvider(
        create: (context) => AllUsersViewModel(),
        child: UsersPage(),
      ),
      TabItem.Blog: BlogPage(),
      TabItem.MyChat : MyChatPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users: GlobalKey<NavigatorState>(), // Yeni nesne
    TabItem.Blog: GlobalKey<NavigatorState>(),
    TabItem.MyChat : GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(), // Yeni nesne
  };

  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CustomBottomNavbar(
        navigatorKeys: navigatorKeys,
        pageBuilder: allPages(),
        currentTab: _currentTab,
        onSelectedTab: (tabItem) {
          if(tabItem == _currentTab){
            navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
          }else{
            setState(() {
              _currentTab = tabItem;
            });
          }
          debugPrint("Seçilen Tab Item : $tabItem");
        },
      ),
    );
  }
}