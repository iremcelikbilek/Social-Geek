import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/responsive/responsive_alert_dialog.dart';
import 'package:social_geek/components/rounded_button.dart';
import 'package:social_geek/components/rounded_input_field.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/settings_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';

Color softSecondColor = Color.fromRGBO(255, 220, 176, 1);

class SettingsPage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("SETTINGS"),
      ),
      body: ProfileSettings(scaffoldKey: scaffoldKey),
    );
  }
}

class ProfileSettings extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  ProfileSettings({this.scaffoldKey});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _focusNode;

  String userName, eMail, aboutMe;

  List<String> subjects = ["turkish","maths","geometry","physics","chemistry","biology"];
  String selectedSubject;

  @override
  void initState() {
    super.initState();
    selectedSubject = subjects[0];
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    var settingsViewModel = Provider.of<SettingsViewModel>(context);
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: Colors.blueGrey, width: 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(75))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: SizeConfig.safeBlockHorizontal * 25,
                        height: SizeConfig.safeBlockVertical * 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: (settingsViewModel.profilePhoto != null) ?FileImage(settingsViewModel.profilePhoto):NetworkImage(userViewModel.userModel.profileURL),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: secondColor.withOpacity(0.5),
                              blurRadius: 30,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: SizeConfig.safeBlockVertical * 4,
                          child: IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: mainColor,
                                size: 35,
                              ),
                              onPressed: (){
                                settingModalBottomSheet(context);
                              }),),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        RoundedInputField(
                          readOnly: true,
                          icon: Icons.email,
                          iconColor: mainColor,
                          cursorColor: secondColor,
                          hintText: "email",
                          onSaved: (value) {
                            eMail = value;
                          },
                          errorText:  null,
                          initialText: userViewModel.userModel.eMail,
                        ),
                        RoundedInputField(
                          focusNode: _focusNode,
                          iconColor: mainColor,
                          cursorColor: secondColor,
                          hintText: "Kullanıcı Adı",
                          onSaved: (value) {
                            userName = value;
                          },
                          errorText: (settingsViewModel.errorText != null) ? settingsViewModel.errorText : null,
                          initialText: userViewModel.userModel.userName,
                        ),
                        RoundedInputField(
                          focusNode: _focusNode,
                          maxLines: null,
                          textInputType: TextInputType.multiline,
                          icon: Icons.info,
                          iconColor: mainColor,
                          cursorColor: secondColor,
                          hintText: "Hakkımda",
                          onSaved: (value) {
                            aboutMe = value;
                          },
                          errorText: null,
                          initialText: userViewModel.userModel.aboutMe,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RoundedButton(
              text: "GÜNCELLE",
              color: backgroundColor,
              press: () {
                _updateUserName(context);
                _updateProfilePhoto(context);
                _updateAboutMe(context);
              }
            ),
            RoundedButton(
                text: "EĞİTMEN OLMAK İSTİYORUM",
                color: backgroundColor,
                press: () {
                    getDialog(context);
                }
            ),
          ],
        ),
      ),
    );
  }

  settingModalBottomSheet(BuildContext context) {
    var settingsViewModel = Provider.of<SettingsViewModel>(context,listen: false);
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () => settingsViewModel.takePhoto(context),
                  leading: Icon(
                    Icons.camera_alt,
                    color: secondColor,
                  ),
                  title: Text(
                    "Kameradan seç",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: () => settingsViewModel.pickImage(context),
                  leading: Icon(
                    Icons.image,
                    color: secondColor,
                  ),
                  title: Text(
                    "Galeriden getir",
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _updateUserName(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context,listen: false);
    final settingsViewModel = Provider.of<SettingsViewModel>(context,listen: false);
    _formKey.currentState.save();
    if(_userViewModel.userModel.userName != userName){
      bool result = await _userViewModel.updateUserName(_userViewModel.userModel.userID, userName);
      if(result){
        ResponsiveAlertDialog(
          title: "BAŞARILI",
          content: "User Name başarılı bir şekilde güncellendi",
          mainButton: "Tamam",
        ).show(context);
      }else{
        userName = _userViewModel.userModel.userName;
        settingsViewModel.errorText = "Bu userName kullanımda";
      }
    }
  }

  void _updateAboutMe(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context,listen: false);
    final settingsViewModel = Provider.of<SettingsViewModel>(context,listen: false);
    _formKey.currentState.save();
    if(_userViewModel.userModel.aboutMe != aboutMe){
      bool result = await _userViewModel.updateAboutMe(_userViewModel.userModel.userID, aboutMe);
      if(result){
        ResponsiveAlertDialog(
          title: "BAŞARILI",
          content: "Hakkınızda başarılı bir şekilde güncellendi",
          mainButton: "Tamam",
        ).show(context);
      }else{
        aboutMe = _userViewModel.userModel.aboutMe;
        settingsViewModel.errorText = "Bu yazı zaten var";
      }
    }
  }

  void _updateProfilePhoto(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context,listen: false);
    final settingsViewModel = Provider.of<SettingsViewModel>(context,listen: false);
    if(settingsViewModel.profilePhoto != null){
      var url = await _userViewModel.uploadFile(_userViewModel.userModel.userID, "profile_photo", settingsViewModel.profilePhoto);
      debugPrint("url: $url");
      if(url != null){
        ResponsiveAlertDialog(
          title: "BAŞARILI",
          content: "Fotoğrafınız başarılı bir şekilde güncellendi",
          mainButton: "Tamam",
        ).show(context);
      }
    }
  }

  void getDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(builder: (context, setState){
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            contentPadding: EdgeInsets.all(10),
            title: Text("Hangi Konuda Eğitim Vermek İstersiniz ?",style: TextStyle(color: mainColor),),
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 2, horizontal: 12),
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: subjects.map((subject){
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject.toUpperCase(),style: TextStyle(color: mainColor, fontWeight: FontWeight.bold,fontSize: 16),),
                      );
                    }).toList(),
                    value: selectedSubject,
                    onChanged: (changedSubject){
                      setState(() {
                        selectedSubject = changedSubject;
                      });
                    },
                  ),
                ),
              ),
              RoundedButton(
                text: "EĞİTMEN OL",
                color: backgroundColor,
                press: () async{
                  var userViewModel = Provider.of<UserViewModel>(context,listen: false);
                  bool result = await userViewModel.saveEducator(selectedSubject, userViewModel.userModel);
                  Navigator.of(context).pop();
                  if(result){
                    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.black,
                        content: Text("Tebrikler artık bir eğitmensiniz.",style: TextStyle(color: Colors.white,),
                        )));
                  }else{
                    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.black,
                        content: Text("Zaten bu konuda eğitim veriyorsunuz.",style: TextStyle(color: Colors.white,),
                        )));
                  }
                },
              ),
            ],
          );
        });

      }
    );
  }
}
