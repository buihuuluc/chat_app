import 'package:flutter/material.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: UniversalVariables.kPrimaryColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: UniversalVariables.blackColor),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: UniversalVariables.whiteColor),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.whiteColor,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "START SEARCHING",
                    style: TextStyle(color: UniversalVariables.kPrimaryColor),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
