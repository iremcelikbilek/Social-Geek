import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/educator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/view_models/chat_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/chat_page.dart';
import 'package:social_geek/views/app/profile/other_user_profile_page.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';

class EducatorPage extends StatefulWidget {
  @override
  _EducatorPageState createState() => _EducatorPageState();
}

class _EducatorPageState extends State<EducatorPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("EĞİTMENLER"),
        bottom: buildTabBar(),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          buildStreamBuilder("turkish"),
          buildStreamBuilder("maths"),
          buildStreamBuilder("geometry"),
          buildStreamBuilder("physics"),
          buildStreamBuilder("chemistry"),
          buildStreamBuilder("biology")
        ],
      ),
    );
  }

  buildStreamBuilder(String subject) {
    var userViewModel = Provider.of<UserViewModel>(context);
    return StreamBuilder(
      stream: userViewModel.getEducators(subject),
      builder: (BuildContext context, AsyncSnapshot<List<Educator>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<Educator> educatorList = snapshot.data;
          if (educatorList.length == 0 || (educatorList.first.educatorID == userViewModel.userModel.userID && educatorList.length == 1)) {
            return Center(
                child: Text(
                  "HENÜZ BU KONUDA EĞİTMEN YOK",
                  style: TextStyle(color: mainColor),
                ));
          }
          return ListView.builder(
            itemCount: educatorList.length,
            itemBuilder: (context, index) {
              return (educatorList[index].educatorID == userViewModel.userModel.userID)
                  ? Container()
                  : Card(
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      elevation: 4.0,
                      color: backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: ListTile(
                        onTap: () async {
                          var user = await userViewModel
                              .getUser(educatorList[index].educatorID);
                          settingModalBottomSheet(context, user);
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              educatorList[index].educatorProfileURL),
                        ),
                        title: Text(educatorList[index].educatorUserName),
                        subtitle: Text(educatorList[index].educatorEmail),
                      ),
                    );
            },
          );
        }
      },
    );
  }

  settingModalBottomSheet(BuildContext context, UserModel delegate) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                OtherUserProfilePage(otherUser: delegate)))
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.arrow_forward_ios,
                    color: secondColor,
                  ),
                  title: Text(
                    "Profile Git",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (context) => ChatViewModel(
                                currentUser: userViewModel.userModel,
                                typedUser: delegate),
                            child: ChatPage()),
                      ),
                    )
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.chat,
                    color: secondColor,
                  ),
                  title: Text(
                    "Sohbet Başlat",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (context) => ChatViewModel(
                                currentUser: userViewModel.userModel,
                                typedUser: delegate),
                            child: ChatPage()),
                      ),
                    )
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.chat,
                    color: secondColor,
                  ),
                  title: Text(
                    "Sohbet Başlat",
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ],
            ),
          );
        });
  }

  TabBar buildTabBar() {
    return TabBar(
        indicatorColor: secondColor,
        isScrollable: true,
        controller: tabController,
        tabs: [
      Tab(
        text: "TÜRKÇE",
      ),
      Tab(
        text: "MATEMATİK",
      ),
      Tab(
        text: "GEOMETRİ",
      ),
      Tab(
        text: "FİZİK",
      ),
      Tab(
        text: "KİMYA",
      ),
      Tab(
        text: "BİYOLOJİ",
      ),
    ]);
  }
}
