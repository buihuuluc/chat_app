import 'package:chat_app/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/enum/user_state.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/appbar.dart';

import 'shimmering_logo.dart';

class UserDetailsContainer extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        authMethods.setUserState(
          userId: userProvider.getUser.uid,
          userState: UserState.Offline,
        );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: UniversalVariables.whiteColor,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: ShimmeringLogo(),
            actions: <Widget>[
              FlatButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                      color: UniversalVariables.whiteColor, fontSize: 15),
                ),
              ),
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Text(
            user.name != null ? user.name : "null",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: UniversalVariables.lightBlueColor,
                fontFamily: UniversalVariables.defaultFont),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Email: ",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.lightBlueColor,
                        fontFamily: UniversalVariables.defaultFont),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Username: ",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.lightBlueColor,
                        fontFamily: UniversalVariables.defaultFont),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Phone: ",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.lightBlueColor,
                        fontFamily: UniversalVariables.defaultFont),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user.email != null ? user.email : "null",
                      style: TextStyle(
                          fontSize: 14,
                          color: UniversalVariables.blackColor,
                          fontFamily: UniversalVariables.defaultFont)),
                  SizedBox(height: 5),
                  Text(user.username != null ? user.username : "null",
                      style: TextStyle(
                          fontSize: 14,
                          color: UniversalVariables.blackColor,
                          fontFamily: UniversalVariables.defaultFont)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.phone != null ? user.phone : "null",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.blackColor,
                        fontFamily: UniversalVariables.defaultFont),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Container(
              height: 300,
              width: 300,
              child: CachedImage(
                user.profilePhoto,
                isRound: true,
                radius: 300,
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Address: ",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.lightBlueColor,
                        fontFamily: UniversalVariables.defaultFont)),
                SizedBox(
                  height: 10,
                ),
                Text("Company: ",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.lightBlueColor,
                        fontFamily: UniversalVariables.defaultFont))
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.add != null ? user.add : "null",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.blackColor,
                        fontFamily: UniversalVariables.defaultFont)),
                SizedBox(
                  height: 10,
                ),
                Text(user.company != null ? user.company : "null",
                    style: TextStyle(
                        fontSize: 14,
                        color: UniversalVariables.blackColor,
                        fontFamily: UniversalVariables.defaultFont))
              ],
            )
          ]),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: [
                  Image.network(
                    "https://www.facebook.com/images/fb_icon_325x325.png",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/2048px-Instagram_icon.png",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.network(
                    "https://freesvg.org/img/1534129544.png",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/LinkedIn_icon_circle.svg/2048px-LinkedIn_icon_circle.svg.png",
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Telegram_2019_Logo.svg/1200px-Telegram_2019_Logo.svg.png",
                    height: 50,
                    width: 50,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
