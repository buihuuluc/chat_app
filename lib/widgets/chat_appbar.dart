import 'package:chat_app/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:chat_app/widgets/appbar.dart';
import 'package:chat_app/screens/pageviews/logs/log_screen.dart';

class SkypeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final List<Widget> actions;

  const SkypeAppBar({
    Key key,
    @required this.title,
    @required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: UniversalVariables.whiteColor,
        ),
        onPressed: () {},
      ),
      title: (title is String)
          ? Text(
              title,
              style: TextStyle(
                color: UniversalVariables.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            )
          : title,
      centerTitle: true,
      actions: actions,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
