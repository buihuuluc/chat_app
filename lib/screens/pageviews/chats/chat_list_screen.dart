import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/chat_methods.dart';
import 'package:chat_app/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chat_app/screens/pageviews/chats/widgets/contact_view.dart';
import 'package:chat_app/screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:chat_app/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/widgets/chat_appbar.dart';

import 'widgets/new_chat_button.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.whiteColor,
        appBar: SkypeAppBar(
          title: UserCircle(),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: UniversalVariables.whiteColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/search_screen");
              },
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: UniversalVariables.whiteColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox(
                  heading: "This is where all the contacts are listed",
                  subtitle:
                      "Search for your friends and family to start calling or chatting with them",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
