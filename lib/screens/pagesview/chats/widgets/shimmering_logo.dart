import 'package:flutter/material.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Shimmer.fromColors(
        baseColor: UniversalVariables.blackColor,
        highlightColor: Colors.white,
        child: Image.asset("assets/logo/new_chat_text.png"),
        // period: Duration(seconds: 0),
      ),
    );
  }
}
