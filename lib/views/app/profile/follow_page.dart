import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';

class FollowPage extends StatefulWidget  {
  final UserModel user;
  FollowPage({@required this.user});

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.userName),
      bottom: buildTabBar(),),
      body: TabBarView(
        controller: tabController,
          children: <Widget>[
            StreamBuilder(
              stream: userViewModel.getFollowers(widget.user),
                builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot){
                List<UserModel> followersList = snapshot.data;
                if(followersList == null){
                  return Center(child: Text("Henüz Takipçiniz Yok",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),));
                }
                return ListView.builder(
                  itemCount: followersList.length,
                    itemBuilder: (context,index){
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    elevation: 4.0,
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(followersList[index].profileURL),),
                      title: Text(followersList[index].userName),
                      subtitle: Text(followersList[index].eMail),
                    ),
                  );
                });
            }),
            StreamBuilder(
                stream: userViewModel.getFollows(widget.user),
                builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot){
                  var followsList = snapshot.data;
                  if(followsList == null){
                    return Center(child: Text("Kimseyi Takip Etmiyorsunuz.",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),));
                  }
                  return ListView.builder(
                      itemCount: followsList.length,
                      itemBuilder: (context,index){
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          elevation: 4.0,
                          color: backgroundColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          child: ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(followsList[index].profileURL),),
                            title: Text(followsList[index].userName),
                            subtitle: Text(followsList[index].eMail),
                          ),
                        );
                      });
                }),
          ]),
    );
  }

  TabBar buildTabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(
        text: "Followers",
      ),
      Tab(
        text: "Follows",
      ),
    ]);
  }
}


