import 'package:flutter/material.dart';
import 'package:chat_app/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chat_app/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/widgets/chat_appbar.dart';

import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.whiteColor,
        appBar: SkypeAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: UniversalVariables.whiteColor,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
