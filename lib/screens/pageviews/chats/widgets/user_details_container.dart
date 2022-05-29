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
                      color: UniversalVariables.whiteColor, fontSize: 12),
                ),
              )
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
          Row(
            children: [
              // CachedImage(
              //   user.profilePhoto,
              //   isRound: true,
              //   radius: 50,
              // ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: UniversalVariables.blueColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Email: " + user.email,
                    style: TextStyle(
                        fontSize: 14, color: UniversalVariables.blackColor),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Username: " + user.username,
                    style: TextStyle(
                        fontSize: 14, color: UniversalVariables.blackColor),
                  ),
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
        ],
      ),
    );
  }
}
