import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/services/database/db_base.dart';

class FirestoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {

    DocumentSnapshot _readUser =
    await _firestore.doc("users/${user.userID}").get();

    if( _readUser.data() == null){
      await _firestore.collection("users").doc(user.userID).set(user.toMap());
      return true;
    }else{
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
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String downloadLink) async {
    await _firestore.collection("users").doc(userID).update({
      'profileURL': downloadLink,
    });
    return true;
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
}

