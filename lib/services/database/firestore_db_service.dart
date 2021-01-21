import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/models/chat.dart';
import 'package:social_geek/models/conversation.dart';
import 'package:social_geek/models/educator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/services/database/db_base.dart';

class FirestoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    DocumentSnapshot _readUser =
    await _firestore.doc("users/${user.userID}").get();

    if (_readUser.data() == null) {
      await _firestore.collection("users").doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }

    /*Map _userInformationMapRead = _readUser.data();
    UserModel _readUserModel = UserModel.fromMap(_userInformationMapRead);
    print("Okunan User Nesnesi : " + _readUserModel.toString());*/

  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUserSnapshot =
    await _firestore.collection("users").doc(userID).get();
    Map<String, dynamic> _readUserMap = _readUserSnapshot.data();
    UserModel _readUser = UserModel.fromMap(_readUserMap);
    debugPrint("Okunan User: ${_readUser.toString()}");
    return _readUser;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    QuerySnapshot updateUser = await _firestore
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (updateUser.docs.length >= 1) {
      return false;
    } else {
      await _firestore.collection("users").doc(userID).update({
        'userName': newUserName,
      });
      await _firestore.collection("blog").doc(userID).update({
        'writer' : newUserName,
      });
      return true;
    }
  }

  @override
  Future<bool> updateAboutMe(String userID, String aboutMe) async {
    QuerySnapshot updateUser = await _firestore.collection("users").where(
        "aboutMe", isEqualTo: aboutMe).get();
    if (updateUser.docs.length >= 1) {
      return false;
    } else {
      await _firestore.collection("users").doc(userID).update(
          {'aboutMe': aboutMe,});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String downloadLink) async {
    await _firestore.collection("users").doc(userID).update({
      'profileURL': downloadLink,
    });
    await _firestore.collection("blog").doc(userID).update({
      'writerProfile' : downloadLink,
    });

  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    List<UserModel> allUsers = [];

    for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
      UserModel user = UserModel.fromMap(userDoc.data());
      allUsers.add(user);
    }
    //WITH MAP
    //allUsers = querySnapshot.docs.map((userDoc) => UserModel.fromMap(userDoc.data())).toList();
    return allUsers;
  }

  // Kendi eklediğim kısım ************
  @override
  Future<UserModel> getUser(String userID) async {
    DocumentSnapshot documentSnapshot =
    await _firestore.collection("users").doc(userID).get();

    UserModel user = UserModel.fromMap(documentSnapshot.data());
    return user;
  }

  ///GÜNCELLEME YAPIYORUM !!!
  @override
  Stream<List<Chat>> getChat(String currentUserID, String typedUserID) {
    Stream<QuerySnapshot> querySnapshot = _firestore
        .collection("chat")
        .doc(currentUserID + "--" + typedUserID)
        .collection("messages")
        .orderBy("sendDate", descending: true)
        .limit(1) //NEW
        .snapshots();

    Stream<List<Chat>> chatListStream = querySnapshot.map((messageList) =>
        messageList.docs
            .map((message) => Chat.fromMap(message.data()))
            .toList());

    return chatListStream;
  }

  @override
  Future<bool> saveMessage(Chat messageToBeSaved, UserModel typedUser,
      currentUser) async {
    var messageID = _firestore
        .collection("chat")
        .doc()
        .id;
    String currentUserDocID =
        messageToBeSaved.fromUser + "--" + messageToBeSaved.toUser;
    String receiverUserDocID =
        messageToBeSaved.toUser + "--" + messageToBeSaved.fromUser;

    await _firestore
        .collection("chat")
        .doc(currentUserDocID)
        .collection("messages")
        .doc(messageID)
        .set(messageToBeSaved.toMap());
    //************************************************
    await _firestore.collection("chat").doc(currentUserDocID).set({
      'chat_owner': messageToBeSaved.fromUser,
      'talking_with': messageToBeSaved.toUser,
      'last_message': messageToBeSaved.message,
      'seen': false, //görüldü
      'creation_date': FieldValue.serverTimestamp(), //oluşturulma tarihi
      'talkingWithUserName': typedUser.userName,
      'talkingWithProfileURL': typedUser.profileURL
    });
    //****************************************************** diğer kişi için
    await _firestore
        .collection("chat")
        .doc(receiverUserDocID)
        .collection("messages")
        .doc(messageID)
        .set({
      'fromUser': messageToBeSaved.fromUser,
      'toUser': messageToBeSaved.toUser,
      'fromMe': false,
      'message': messageToBeSaved.message,
      'sendDate': messageToBeSaved.sendDate ?? FieldValue.serverTimestamp()
    });

    await _firestore.collection("chat").doc(receiverUserDocID).set({
      'chat_owner': messageToBeSaved.toUser,
      'talking_with': messageToBeSaved.fromUser,
      'last_message': messageToBeSaved.message,
      'seen': false, //görüldü
      'creation_date': FieldValue.serverTimestamp(), //oluşturulma tarihi
      'talkingWithUserName': currentUser.userName,
      'talkingWithProfileURL': currentUser.profileURL
    });

    return true;
  }

  @override
  Stream<List<Conversation>> getAllConversation(String userID) {
    Stream<QuerySnapshot> querySnapshot = _firestore
        .collection("chat")
        .where("chat_owner", isEqualTo: userID)
        .orderBy("creation_date", descending: true)
        .snapshots();

    Stream<List<Conversation>> allConversations = querySnapshot.map(
            (conversationList) =>
            conversationList.docs
                .map((conversationDoc) =>
                Conversation.fromMap(conversationDoc.data()))
                .toList());
    return allConversations;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firestore.collection("server").doc(userID).set({
      'time': FieldValue.serverTimestamp(),
    });

    DocumentSnapshot snapshot =
    await _firestore.collection("server").doc(userID).get();
    Timestamp time = snapshot.data()['time'];

    return time.toDate();
  }

  @override
  Future<List<UserModel>> getUsersWithPagination(UserModel theLastUserToGet,
      int elementToBeGet) async {
    QuerySnapshot querySnapshot;
    List<UserModel> allUsers = [];
    //Liste ilk defa gelecekse baştan başlayıp elementToBeGet'e kadar alırız.
    if (theLastUserToGet == null) {
      querySnapshot = await _firestore
          .collection("users")
          .orderBy("userName")
          .limit(elementToBeGet)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection("users")
          .orderBy("userName")
          .startAfter([theLastUserToGet.userName])
          .limit(elementToBeGet)
          .get();
      debugPrint("else içine girdim");
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      UserModel singleUser = UserModel.fromMap(snapshot.data());
      allUsers.add(singleUser);
    }

    return allUsers;
  }

  Future<List<Chat>> getChatWithPagination(String currentUserID,
      String typedUserID, Chat theLastMessageToBeGet,
      int elementToBeGet) async {
    QuerySnapshot querySnapshot;
    List<Chat> allMessages = [];

    if (theLastMessageToBeGet == null) {
      querySnapshot = await _firestore
          .collection("chat")
          .doc(currentUserID + "--" + typedUserID)
          .collection("messages")
          .orderBy("sendDate", descending: true)
          .limit(elementToBeGet)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection("chat")
          .doc(currentUserID + "--" + typedUserID)
          .collection("messages")
          .orderBy("sendDate", descending: true)
          .startAfter([theLastMessageToBeGet.sendDate])
          .limit(elementToBeGet)
          .get();
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      Chat singleMessage = Chat.fromMap(snapshot.data());
      allMessages.add(singleMessage);
    }

    return allMessages;
  }

  Future<String> getToken(String toUser) async {
    DocumentSnapshot snapshot = await _firestore.doc("tokens/$toUser").get();
    if (snapshot != null)
      return snapshot.data()["token"];
    else
      return null;
  }
  ///TAKİP İŞLEMLERİ

  Stream<int> getFollowsNumber(UserModel userMe) {
    Stream<QuerySnapshot> snapshot = _firestore.collection("users").doc(userMe.userID)
        .collection("follows").where("isFollow", isEqualTo: true).snapshots();

    return snapshot.map((followsList) => followsList.docs.length);
  }

  Stream<int> getFollowersNumber(UserModel userMe){
    Stream<QuerySnapshot> snapshot =  _firestore.collection("users").doc(userMe.userID)
        .collection("followers").where("isFollower", isEqualTo: true).snapshots();
    return snapshot.map((followersList) => followersList.docs.length);
  }

  Future<bool> checkFollow(UserModel userMe, UserModel otherUser) async{
    DocumentSnapshot snapshot = await _firestore.collection("users").doc(userMe.userID).collection("follows").doc(otherUser.userID).get();
    return snapshot.data()['isFollow'];
  }

  Future<bool> saveFollows(UserModel userMe, UserModel otherUser) async{
    await _firestore.collection("users").doc(userMe.userID).collection("follows").doc(otherUser.userID).set({
      "isFollow" : true,
      "userName" : otherUser.userName,
      "eMail" : otherUser.eMail,
      "profileURL" : otherUser.profileURL
    });
    await _firestore.collection("users").doc(otherUser.userID).collection("followers").doc(userMe.userID).set({
      "isFollower" : true,
      "userName" : userMe.userName,
      "eMail" : userMe.eMail,
      "profileURL" : userMe.profileURL
    });
    return true;
  }

  Future<bool> saveUnfollow(UserModel userMe, UserModel otherUser) async{
    await _firestore.collection("users").doc(userMe.userID).collection("follows").doc(otherUser.userID).update({
      "isFollow" : false
    });
    await _firestore.collection("users").doc(otherUser.userID).collection("followers").doc(userMe.userID).update({
      "isFollower" : false
    });
    return true;
  }

  Stream<List<UserModel>> getFollows(UserModel userMe) {
    Stream<QuerySnapshot> querySnapshot = _firestore.collection("users").doc(userMe.userID)
        .collection("follows").where("isFollow",isEqualTo: true).snapshots();

    Stream<List<UserModel>> followsList = querySnapshot.map((followsList) =>
        followsList.docs.map((followDoc) =>
            UserModel.fromMapFollow(followDoc.data())
        ).toList()
    );

    return followsList;
  }

  Stream<List<UserModel>> getFollowers(UserModel userMe) {
    Stream<QuerySnapshot> querySnapshot = _firestore.collection("users").doc(userMe.userID)
        .collection("followers").where("isFollower",isEqualTo: true).snapshots();

    Stream<List<UserModel>> followersList = querySnapshot.map((followersList) =>
        followersList.docs.map((followerDoc) =>
            UserModel.fromMapFollower(followerDoc.data())
        ).toList()
    );

    return followersList;
  }

  ///BLOG İŞLMELEMLERİ *********

  Future<bool> saveBlogPost(UserModel userModel, Blog blogPost) async{
    await _firestore.collection("blog").doc().set(
      blogPost.toMap()
    );
    return true;
  }

  Stream<List<Blog>> getAllBlogPost(){
    Stream<QuerySnapshot> querySnapshot = _firestore.collection("blog").snapshots();

    Stream<List<Blog>> allBlogPostList = querySnapshot.map((blogList) =>
        blogList.docs.map((blogDoc) =>
            Blog.fromMap(blogDoc.data())
        ).toList()
    );
    return allBlogPostList;
  }

  Stream<List<Blog>> getMyBlog(UserModel user){
    Stream<QuerySnapshot> querySnapshot = _firestore.collection("blog").where("writerID",isEqualTo: user.userID).snapshots();

    Stream<List<Blog>> allMyBlog = querySnapshot.map((blogList) =>
        blogList.docs.map((blogDoc) =>
            Blog.fromMap(blogDoc.data())
        ).toList()
    );
    return allMyBlog;
  }

  Future<List<Blog>> getBlogWithPagination(Blog theLastBlogToGet, int elementToBeGet) async {
    QuerySnapshot querySnapshot;
    List<Blog> allBlog = [];
    //Liste ilk defa gelecekse baştan başlayıp elementToBeGet'e kadar alırız.
    if (theLastBlogToGet == null) {
      querySnapshot = await _firestore
          .collection("blog")
          .orderBy("article")
          .limit(elementToBeGet)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection("blog")
          .orderBy("article")
          .startAfter([theLastBlogToGet.article])
          .limit(elementToBeGet)
          .get();
      debugPrint("else içine girdim");
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      Blog singleBlog = Blog.fromMap(snapshot.data());
      allBlog.add(singleBlog);
    }

    return allBlog;
  }


  /// EDUCATOR İŞLEMLERİ

  Future<bool> saveEducator(String subject, UserModel educator) async{
    QuerySnapshot querySnapshot = await _firestore.collection("subjects").doc(subject).collection("educator").where("educatorID", isEqualTo: educator.userID).get();
    if(querySnapshot.docs.length >= 1){
      //zaten kayıtlı eğitmen tekrar istek atıyor demektir.
      return false;
    }else{
      await _firestore.collection("subjects").doc(subject).collection("educator").doc(educator.userID).set({
        'educatorID' : educator.userID,
        'educatorUserName' : educator.userName,
        'educatorEmail' : educator.eMail,
        'educatorProfileURL' : educator.profileURL,
      });
      return true;
    }
  }

  Stream<List<Educator>> getEducators(String subject) {
    Stream<QuerySnapshot> querySnapshot = _firestore.collection("subjects").doc(subject).collection("educator").snapshots();

    Stream<List<Educator>> educatorList = querySnapshot.map((educatorList) =>
        educatorList.docs.map((educatorDoc) =>
            Educator.fromMap(educatorDoc.data())
        ).toList()
    );
    return educatorList;
  }

}


