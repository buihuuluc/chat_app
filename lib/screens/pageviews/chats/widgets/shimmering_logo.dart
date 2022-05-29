import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chat_app/utils/universal_variables.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.white,
        child: Image.asset("assets/logo/new_chat_logo.png"),
        period: Duration(seconds: 1),
      ),
    );
  }
}
