import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_geek/services/storage/storage_base.dart';

class FirebaseStorageService implements StorageBase{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Reference _reference;

  @override
  Future<String> uploadFile(String userID, String fileType, File fileToUpload) async{
    _reference = _firebaseStorage.ref().child(userID).child(fileType).child("${DateTime.now().millisecondsSinceEpoch}.${fileToUpload.path.split(".").last}");
    UploadTask uploadTask =  _reference.putFile(fileToUpload);
    String url;
    await uploadTask.whenComplete(() async{
      url = await uploadTask.snapshot.ref.getDownloadURL();
    });
    return url;
  }

}