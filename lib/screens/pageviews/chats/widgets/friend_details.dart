import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:chat_app/screens/pageviews/chats/widgets/shimmering_logo.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendDetails extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  FriendDetails({Key key, this.receiver});
  User receiver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: UniversalVariables.whiteColor,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          centerTitle: true,
          title: ShimmeringLogo(),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Text(
                receiver.name != null ? receiver.name : "null",
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
                      Text(receiver.email != null ? receiver.email : "null",
                          style: TextStyle(
                              fontSize: 14,
                              color: UniversalVariables.blackColor,
                              fontFamily: UniversalVariables.defaultFont)),
                      SizedBox(height: 5),
                      Text(
                          receiver.username != null
                              ? receiver.username
                              : "null",
                          style: TextStyle(
                              fontSize: 14,
                              color: UniversalVariables.blackColor,
                              fontFamily: UniversalVariables.defaultFont)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        receiver.phone != null ? receiver.phone : "null",
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
                    receiver.profilePhoto,
                    isRound: true,
                    radius: 300,
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
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
                    Text(receiver.add != null ? receiver.add : "null",
                        style: TextStyle(
                            fontSize: 14,
                            color: UniversalVariables.blackColor,
                            fontFamily: UniversalVariables.defaultFont)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(receiver.company != null ? receiver.company : "null",
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
        ));
  }
}
