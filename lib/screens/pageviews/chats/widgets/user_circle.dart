import 'package:chat_app/models/user.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/utils/utilities.dart';

import 'user_details_container.dart';

class UserCircle extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: UniversalVariables.whiteColor,
        builder: (context) => UserDetailsContainer(),
      ),
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(44), color: Colors.blueGrey),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child:
                  // Text(
                  //   Utils.getInitials(userProvider.getUser.name),
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: UniversalVariables.kPrimaryColor,
                  //     fontSize: 16,
                  //   ),
                  // ),
                  CachedImage(
                user.profilePhoto,
                isRound: true,
                radius: 40,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 1),
                  color: UniversalVariables.onlineDotColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
