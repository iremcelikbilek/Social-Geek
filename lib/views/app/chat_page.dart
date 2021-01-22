import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/chat.dart';
import 'package:social_geek/view_models/chat_view_model.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';
import 'package:social_geek/views/call_page.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final PermissionHandler _permissionHandler = PermissionHandler();
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(chatViewModel.typedUser.userName),
        actions: [
          IconButton(icon: Icon(Icons.video_call),onPressed: () async{

            await _permissionHandler.requestPermissions([PermissionGroup.camera, PermissionGroup.microphone]);

            Navigator.push(context,
                MaterialPageRoute(
                  builder: (context)=> CallPage(),)
            );
          },)
        ],
      ),
      body: (chatViewModel.chatViewState == ChatViewState.Busy)
          ? _waitForNewUserList()
          : Center(
        child: Container(
          color: backgroundColor,
          child: GestureDetector(
            onTap: () => _focusNode.unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildMessageListArea(),
                buildNewMessageSendArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMessageListArea() {
    return Consumer<ChatViewModel>(
      builder: (BuildContext context, ChatViewModel model, Widget child){
        return Expanded(
          child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: (model.hasMore) ? model.allChat.length + 1 : model.allChat.length,
              itemBuilder: (context, index) {
                if(model.hasMore && model.allChat.length == index){
                  return _waitForNewUserList();
                }else return _createMessageBalloon(model.allChat[index]);
              }),
        );
      },
    );
  }

  Widget buildNewMessageSendArea()  {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              controller: _messageController,
              cursorColor: Colors.blueGrey,
              style: TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                hintText: "Mesaj yazın",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: secondColor,
              child: Icon(
                Icons.send,
                size: 35,
                color: Colors.white
              ),
              onPressed: () async {
                if (_messageController.text.trim().length > 0) {
                  Chat messageToBeSaved = Chat(
                    fromUser: chatViewModel.currentUser.userID,
                    toUser: chatViewModel.typedUser.userID,
                    fromMe: true,
                    message: _messageController.text,
                  );
                  bool result = await chatViewModel
                      .saveMessage(messageToBeSaved,chatViewModel.typedUser, chatViewModel.currentUser);
                  if (result) {
                    _messageController.clear();
                    _scrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeOut);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMessageBalloon(Chat message) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    Color incomingMessage = darkBackgroundColor;
    Color outgoingMessage = secondColor;
    bool fromMe = message.fromMe; // Eğer bendense(true) outgoingMessage false ise incoming message

    var hourMinuteValue = "";

    try{
      hourMinuteValue =  _showHourMinute(message.sendDate ?? Timestamp(1,1)) ;
    }catch(e){
      debugPrint("Saat çevirmede hata : $e");
    }

    if (fromMe) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: outgoingMessage,
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text(hourMinuteValue, style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(chatViewModel.typedUser.profileURL),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: incomingMessage,
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(hourMinuteValue, style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _waitForNewUserList() {
    return Padding(padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String _showHourMinute(Timestamp sendDate) {
    var formatter = DateFormat.Hm();
    var formattedDate = formatter.format(sendDate.toDate());
    return formattedDate;
  }

  void _scrollListener() {
    if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange ){
      getOldMessages();
    }
  }

  void getOldMessages() async{
    print("Listenin en üstündeyiz eski mesajları getir");
    final chatViewModel = Provider.of<ChatViewModel>(context,listen: false);

    if(_isLoading == false){
      _isLoading = true;
      await chatViewModel.getMoreMessages();
      _isLoading = false;
    }
  }


}

