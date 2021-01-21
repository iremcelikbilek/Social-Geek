import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/all_users_view_model.dart';
import 'package:social_geek/view_models/chat_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/chat_page.dart';
import 'package:social_geek/views/app/educator_page.dart';
import 'package:social_geek/views/app/profile/other_user_profile_page.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';
import 'package:social_geek/views/app/profile/settings_page.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset('assets/images/social_geek_logo.png', width: 50,height: 50,),),),
      body: InstaHome(),
    );
  }
}

class InstaHome extends StatefulWidget {
  @override
  _InstaHomeState createState() => _InstaHomeState();
}

class _InstaHomeState extends State<InstaHome> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GetPostsList(),
        GetHeader(),
      ],
    );
  }
}


class GetHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EducatorPage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: SizeConfig.safeBlockVertical*12,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text("Eğitmenlere Göz At",style: TextStyle(color: mainColor,fontWeight: FontWeight.bold,fontSize: 25),)),
            SizedBox(width: SizeConfig.safeBlockHorizontal,),
            Icon(Icons.arrow_forward_ios,color: mainColor)
          ],
        ),
      ),
    );
  }

}

class GetPostsList extends StatefulWidget{
  @override
  _GetPostsListState createState() => _GetPostsListState();
}

class _GetPostsListState extends State<GetPostsList> {

  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 112),
        child: Consumer<AllUsersViewModel>(
          builder: (BuildContext context, AllUsersViewModel model, Widget child){
            if(model.state == AllUserViewState.Busy){
              return Center(child: CircularProgressIndicator());
            }else if(model.state == AllUserViewState.Loaded){
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (model.hasMore) ? model.allUsers.length + 1 : model.allUsers.length,
                  itemBuilder: (context, index) {
                    if(model.hasMore && index == model.allUsers.length){
                      return _waitForNewUserList();
                    }else{
                      return _userListDelegate(index);
                    }
                  },
                ),
              );
            }else{
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _userListDelegate(int index) {

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final allUsersViewModel = Provider.of<AllUsersViewModel>(context);

    var delegate = allUsersViewModel.allUsers[index];

    if(delegate.userID == userViewModel.userModel.userID) return Container();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor, borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(delegate.profileURL)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  delegate.userName,
                  style: TextStyle(fontSize: 17,color: mainColor,fontWeight: FontWeight.w900),),
                ),
              IconButton(icon: Icon(Icons.more_horiz), onPressed: () => settingModalBottomSheet(context,delegate),)
            ],
          ),
          SizedBox(height: SizeConfig.safeBlockVertical*2,),
          Text("BILGILERIM :",style: TextStyle(fontFamily: "HachiMaruPop",fontSize: 17,color: secondColor,fontWeight: FontWeight.bold),),
          SizedBox(height: SizeConfig.safeBlockVertical*1,),
          Row(
            children: [
              Icon(Icons.done,color: secondColor,),
              Text("  "+delegate.eMail,style: TextStyle(fontSize: 17,color: mainColor,fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              Icon(Icons.done,color: secondColor,),
              Text("  Hakkımda : ", style: TextStyle(fontSize: 17,color: mainColor,fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              Text("        "),
              Flexible(child: Text( delegate.aboutMe ?? "Merhabalar", style: TextStyle(fontSize: 17,color: mainColor,fontWeight: FontWeight.bold),)),
            ],
          ),
        ],
      ),
    );
  }

  settingModalBottomSheet(BuildContext context, UserModel delegate) {
    var userViewModel = Provider.of<UserViewModel>(context,listen: false);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtherUserProfilePage(otherUser: delegate))).then((value){
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
                  onTap: (){
                    print("Typed User : $delegate");
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(currentUser: userViewModel.userModel, typedUser: delegate),
                          child: ChatPage()
                      ),
                      ),
                    ).then((value){
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
                  onTap: (){
                    print("Typed User : $delegate");
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(currentUser: userViewModel.userModel, typedUser: delegate),
                          child: ChatPage()
                      ),
                      ),
                    ).then((value){
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

  Widget _waitForNewUserList() {
    return Padding(padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),);
  }

  void _listScrollListener() {
    if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange ){
      getMoreUsers();
    }
  }

  void getMoreUsers() async{
    if(_isLoading == false){
      _isLoading = true;
      final allUsersViewModel = Provider.of<AllUsersViewModel>(context,listen: false);
      await allUsersViewModel.getMoreUsers();
      _isLoading = false;
    }
  }
}





