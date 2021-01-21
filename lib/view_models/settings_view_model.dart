import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class SettingsViewModel with ChangeNotifier{

  File _profilePhoto;
  String _errorText;

  String get errorText => _errorText;

  set errorText(String value) {
    _errorText = value;
    notifyListeners();
  }

  File get profilePhoto => _profilePhoto;

  set profilePhoto(File value) {
    _profilePhoto = value;
    notifyListeners();
  }


  void takePhoto(BuildContext context) async{
    PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    profilePhoto = File(pickedFile.path);
  }

  void pickImage(BuildContext context) async{
    PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    profilePhoto = File(pickedFile.path);
  }


}