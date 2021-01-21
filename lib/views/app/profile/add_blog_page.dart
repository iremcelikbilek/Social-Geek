import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/responsive/responsive_alert_dialog.dart';
import 'package:social_geek/components/rounded_button.dart';
import 'package:social_geek/components/rounded_input_field.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';
import 'package:social_geek/views/app/profile/settings_page.dart';

class AddBlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD BLOG"),
      ),
      body: ProfileSettings(),
    );
  }
}

class ProfileSettings extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String userName, title, article;
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: darkBackgroundColor,
                border: Border.all(color: Colors.blueGrey, width: 0.4),
                borderRadius: BorderRadius.all(Radius.circular(75))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: SizeConfig.safeBlockHorizontal * 25,
                  height: SizeConfig.safeBlockVertical * 25,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(userViewModel.userModel.profileURL),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        readOnly: true,
                        icon: Icons.person_pin,
                        iconColor: mainColor,
                        cursorColor: mainColor,
                        hintText: "User Name",
                        onSaved: (value) {
                          userName = value;
                        },
                        errorText:  null,
                        initialText: userViewModel.userModel.userName,
                      ),
                      RoundedInputField(
                        icon: Icons.title,
                        iconColor: mainColor,
                        cursorColor: mainColor,
                        hintText: "Başlık",
                        onSaved: (value) {
                          title = value;
                        },
                        errorText: null,
                      ),
                      RoundedInputField(
                        maxLines: null,
                        textInputType: TextInputType.multiline,
                        icon: Icons.article,
                        iconColor: mainColor,
                        cursorColor: mainColor,
                        hintText: "Makale",
                        onSaved: (value) {
                          article = value;
                        },
                        errorText: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RoundedButton(
              text: "MAKALE EKLE",
              color: backgroundColor,
              press: () {
                saveBlogPost(context);
              }
          ),
        ],
      ),
    );
  }

  void saveBlogPost(BuildContext context) async{
    final userViewModel = Provider.of<UserViewModel>(context,listen: false);
    _formKey.currentState.save();
    Blog newBlog = Blog(writerID: userViewModel.userModel.userID, writer: userViewModel.userModel.userName, writerProfile: userViewModel.userModel.profileURL ,title: title,article: article);
    bool result = await userViewModel.saveBlogPost(userViewModel.userModel, newBlog);
    if(result){
      ResponsiveAlertDialog(
        title: "BAŞARILI",
        content: "Blog başarılı bir şekilde oluşturuldu.",
        mainButton: "Tamam",
      ).show(context);
    }else{
      ResponsiveAlertDialog(
        title: "BAŞARISIZ",
        content: "Blog oluşturulamadı lütfen tekrar deneyin",
        mainButton: "Tamam",
      ).show(context);
    }
  }
}
