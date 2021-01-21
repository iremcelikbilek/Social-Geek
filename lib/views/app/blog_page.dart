import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/all_blog_view_model.dart';
import 'package:social_geek/view_models/all_users_view_model.dart';
import 'package:social_geek/view_models/chat_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/chat_page.dart';
import 'package:social_geek/views/app/profile/other_user_profile_page.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset('assets/images/social_geek_logo.png', width: 50,height: 50,),),),
      body: ChangeNotifierProvider(
        create: (context) => AllBlogViewModel(),
          child: GetPostsList()),
    );
  }
}

class GetPostsList extends StatefulWidget {

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
        child: Consumer<AllBlogViewModel>(
          builder: (BuildContext context, AllBlogViewModel model, Widget child){
            if(model.state == AllBlogViewState.Busy){
              return Center(child: CircularProgressIndicator());
            }else if(model.state == AllBlogViewState.Loaded){
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (model.hasMore) ? model.allBlog.length + 1 : model.allBlog.length,
                  itemBuilder: (context, index) {
                    if(model.hasMore && index == model.allBlog.length){
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
    final allBlogViewModel = Provider.of<AllBlogViewModel>(context);

    var delegate = allBlogViewModel.allBlog[index];

    if(delegate.writerID == userViewModel.userModel.userID) return Container();
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(delegate.writerProfile)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  delegate.writer,
                  style: TextStyle(fontSize: 17,color: mainColor,fontWeight: FontWeight.w900),),
              ),
              IconButton(icon: Icon(Icons.more_horiz),
                onPressed: () => settingModalBottomSheet(context,delegate),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.safeBlockVertical*2,),
          Text("${delegate.title} :",style: TextStyle(fontFamily: "HachiMaruPop",fontSize: 17,color: secondColor,fontWeight: FontWeight.bold),),
          SizedBox(height: SizeConfig.safeBlockVertical*1,),
          Row(
            children: [
              Icon(Icons.done,color: secondColor,),
              Flexible(child: Text("  "+delegate.article,style: TextStyle(fontSize: 17,color: mainColor,fontWeight: FontWeight.bold),)),
            ],
          ),
        ],
      ),
    );
  }

  settingModalBottomSheet(BuildContext context, Blog delegate) async{
    var userViewModel = Provider.of<UserViewModel>(context,listen: false);
    var otherUser = await userViewModel.getUser(delegate.writerID);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtherUserProfilePage(otherUser: otherUser))).then((value){
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
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(currentUser: userViewModel.userModel, typedUser: otherUser),
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
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(currentUser: userViewModel.userModel, typedUser: otherUser),
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
      getMoreBlog();
    }
  }

  void getMoreBlog() async{
    if(_isLoading == false){
      _isLoading = true;
      final allBlogViewModel = Provider.of<AllBlogViewModel>(context,listen: false);
      await allBlogViewModel.getMoreBlog();
      _isLoading = false;
    }
  }
}





