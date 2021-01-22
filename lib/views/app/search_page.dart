import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/locator.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/view_models/chat_view_model.dart';
import 'package:social_geek/view_models/search_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/chat_page.dart';
import 'package:social_geek/views/app/profile/other_user_profile_page.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';


class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text("Search"),
        actions: [
          IconButton(icon: Icon(Icons.search_rounded), onPressed: (){
            showSearch(context: context, delegate: ContactSearchDelegate());
          }),
        ],),
      body: ContactsList(),
    );
  }
}

class ContactsList extends StatelessWidget {

  final String query;

  const ContactsList({
    Key key,
    this.query
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var searchViewModel = locator<SearchViewModel>();
    //var userViewModel = Provider.of<UserViewModel>(context);
    return FutureBuilder(
      future: searchViewModel.getSearch(query),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot){
        if(snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"),);
        }else if(!snapshot.hasData){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Yükleniyor",style: TextStyle(fontSize: 20),)
            ],
          );
        }
        return ListView(
          children: [
            ...snapshot.data.map((user) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profileURL),
              ),
              title: Text(user.userName),
              onTap: () {
                settingModalBottomSheet(context, user);
              },

            )).toList(),
          ],
        );
      },
    );
  }

  settingModalBottomSheet(BuildContext context, UserModel delegate) {
    var userViewModel = Provider.of<UserViewModel>(context,listen: false);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtherUserProfilePage(otherUser: delegate))).then((value){
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.arrow_forward_ios,
                    color: secondColor,
                  ),
                  title: Text(
                    "Profile Git",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: (){
                    print("Typed User : $delegate");
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(currentUser: userViewModel.userModel, typedUser: delegate),
                          child: ChatPage()
                      ),
                      ),
                    ).then((value){
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.chat,
                    color: secondColor,
                  ),
                  title: Text(
                    "Sohbet Başlat",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: (){
                    print("Typed User : $delegate");
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(currentUser: userViewModel.userModel, typedUser: delegate),
                          child: ChatPage()
                      ),
                      ),
                    ).then((value){
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.chat,
                    color: secondColor,
                  ),
                  title: Text(
                    "Sohbet Başlat",
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ContactSearchDelegate extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme => halihazırda olan theme datayı kullanmak için override ediyoruz.
    final theme = Theme.of(context);
    return theme;
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions => delegate'in sağ tarafına icon koymamızı sağlıyor.
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading => delegate'in sol tarafına icon koymamızı sağlıyor.
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults => search kısmındaki değişikliklerden sonra gösterilecek widget
    return ContactsList(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions => bu delegate çağrıldığında gösterilecek ilk widget
    return Center(child: Text("Start Searching to User"),);
  }

}
