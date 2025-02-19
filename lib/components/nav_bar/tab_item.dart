import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {Users, Blog, MyChat, Profile}

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users : TabItemData("Users", Icons.supervised_user_circle),
    TabItem.Blog : TabItemData("Blog", Icons.article),
    TabItem.MyChat : TabItemData("My Chat", Icons.chat),
    TabItem.Profile : TabItemData("Profile", Icons.person),
  };
}