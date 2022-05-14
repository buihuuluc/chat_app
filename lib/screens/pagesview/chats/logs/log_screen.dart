import 'package:flutter/material.dart';
import 'package:chat_app/screens/call_screen/pickup/pickup_layout.dart';
import 'package:chat_app/screens/pagesview/logs/widgets/floating_column.dart';
import 'package:chat_app/screens/pagesview/logs/widgets/log_list_container.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/widgets/skype_appbar.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
