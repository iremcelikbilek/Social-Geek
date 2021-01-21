
import 'package:http/http.dart' as http;
import 'package:social_geek/models/chat.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/private_key.dart';

class NotificationService {
  Future<bool> sendNotification(Chat sendMessage, UserModel senderUser, String token) async{
    String postURL = "https://fcm.googleapis.com/fcm/send" ;
    var key = firebaseKey;
    Map<String, String> headers = {
      "Content-Type" : "application/json",
      "Authorization" : "key=$key"
    };

    String json = '{"to" : "$token","data" : {"title" : "${senderUser.userName} size mesaj gönderdi","message" : "${sendMessage.message}", "profileURL" : "${senderUser.profileURL}", "senderUserID" : "${senderUser.userID}"}}';

    http.Response response = await http.post(postURL, headers: headers, body: json);

    if(response.statusCode == 200){
      print("Notification işlemi başarılı");
    }else{
      print("Notification işlemi başarısız : ${response.statusCode}");
    }

  }
}