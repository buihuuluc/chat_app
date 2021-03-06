import 'package:chat_app/screens/pageviews/chats/widgets/friend_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/resources/chat_methods.dart';
import 'package:chat_app/screens/chatscreens/chat_screen.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:chat_app/widgets/custom_tile.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'last_message_container.dart';
import 'online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      title: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiver: contact,
              ),
            )),
        child: Text(
          (contact != null ? contact.name : null) != null ? contact.name : "..",
          style: TextStyle(
              color: UniversalVariables.blackColor,
              fontFamily: UniversalVariables.defaultFont,
              fontSize: 19),
        ),
      ),
      subtitle: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiver: contact,
              ),
            )),
        child: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.uid,
            receiverId: contact.uid,
          ),
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendDetails(
                      receiver: contact,
                    ),
                  )),
              child: CachedImage(
                contact.profilePhoto,
                radius: 80,
                isRound: true,
              ),
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
