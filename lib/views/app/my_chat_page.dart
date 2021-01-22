import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/conversation.dart';
import 'package:social_geek/view_models/chat_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/chat_page.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyChatPage extends StatefulWidget {
  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {

  @override
  Widget build(BuildContext context) {
    var _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("My Chat")),),
      body: Container(
        color: backgroundColor,
        child: StreamBuilder(
          stream: _userViewModel.getAllConversation(_userViewModel.userModel.userID),
          builder: (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }else{
              var allConversations = snapshot.data;
              if(allConversations.length >0 ){
                return ListView.builder(
                  itemCount: allConversations.length,
                  itemBuilder: (context, index){
                    var duration = DateTime.now().difference(allConversations[index].creation_date.toDate());
                    timeago.setLocaleMessages("tr", timeago.TrMessages());
                    var aradakiFark = timeago.format(DateTime.now().subtract(duration),locale: "tr");
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkBackgroundColor, borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        onTap: () async{
                          var typedUser = await _userViewModel.getUser(allConversations[index].talking_with);
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                create: (context) => ChatViewModel(currentUser: _userViewModel.userModel, typedUser: typedUser),
                                child: ChatPage()
                            ),),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(allConversations[index].talkingWithProfileURL),
                        ),
                        title: Text(allConversations[index].talkingWithUserName,style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(allConversations[index].last_message,style: TextStyle(color: mainColor),)),
                            Text(aradakiFark,style: TextStyle(color: mainColor),),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }else{
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat,size: 50,color: Colors.white,),
                      Text("Henüz Konuşmanız Yok",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

}
