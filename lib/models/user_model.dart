import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String userID;
  String eMail;
  String userName;
  String profileURL;
  DateTime createdAt;
  DateTime updatedAt;
  String aboutMe;
  bool isFollow;
  bool isFollower;

  UserModel({@required this.userID, @required this.eMail});

  Map<String, dynamic> toMap(){
    return {
      'userID' : userID,
      'eMail' : eMail,
      'userName' : userName ?? eMail.substring(0, eMail.indexOf("@")) + generateRandomNumber(),
      'profileURL' : profileURL ?? 'https://png.pngtree.com/png-clipart/20190629/original/pngtree-vector-edit-profile-icon-png-image_4102545.jpg',
      'createdAt' : createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt' : updatedAt ?? FieldValue.serverTimestamp(),
      'aboutMe' : aboutMe ?? "",
      "isFollow" : isFollow ?? false,
      "isFollower" : isFollower ?? false
    };
  }

  UserModel.fromMapFollow(Map<String, dynamic> map) :
        userName = map['userName'],
        eMail = map['eMail'],
        profileURL = map['profileURL'],
        isFollow = map['isFollow'];

  UserModel.fromMapFollower(Map<String, dynamic> map) :
        userName = map['userName'],
        eMail = map['eMail'],
        profileURL = map['profileURL'],
        isFollower = map['isFollower'];

  UserModel.fromMap(Map<String, dynamic> map) :
        userID = map['userID'],
        eMail = map['eMail'],
        userName = map['userName'],
        profileURL = map['profileURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        aboutMe = map['aboutMe'];


  String generateRandomNumber() {
    int randNumber = Random().nextInt(99999);
    return randNumber.toString();
  }

  @override
  String toString() {
    return 'UserModel{userID: $userID, eMail: $eMail, userName: $userName, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, aboutMe: $aboutMe}';
  }
}