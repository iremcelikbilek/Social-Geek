class Educator{
  String educatorID;
  String educatorUserName;
  String educatorEmail;
  String educatorProfileURL;

  Educator({this.educatorID, this.educatorUserName, this.educatorEmail, this.educatorProfileURL});

  Map<String, dynamic> toMap(){
    return {
      'educatorID' : educatorID,
      'educatorUserName' : educatorUserName,
      'educatorEmail' : educatorEmail,
      'educatorProfileURL' : educatorProfileURL,
    };
  }

  Educator.fromMap(Map<String, dynamic> map) :
      this.educatorID = map['educatorID'],
      this.educatorUserName = map['educatorUserName'],
      this.educatorEmail = map['educatorEmail'],
      this.educatorProfileURL = map['educatorProfileURL'];
}