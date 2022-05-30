import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: [
          Center(
            child: loginButton(),
          ),
          isLoginPressed
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget loginButton() {
    return Center(
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: CachedImage(
                "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png",
                height: 200,
                width: 200,
              ),
              onPressed: () => performLogin(),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text(
                        "Sign in with Google Account",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => performLogin(),
                    ),
                  ],
                ))
          ],
        ),
      ]),
    );
    // Shimmer.fromColors(
    //   baseColor: Colors.white,
    //   highlightColor: UniversalVariables.senderColor,
    //   child: FlatButton(
    //     padding: EdgeInsets.all(35),
    //     child: CachedImage(
    //       "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png",
    //       height: 50,
    //       width: 50,
    //     ),
    //     onPressed: () => performLogin(),
    //     // child: Text(
    //     //   "LOGIN",
    //     //   style: TextStyle(
    //     //       fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
    //     // ),
    //     // onPressed: () => performLogin(),
    //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   ),
    // );
  }

  void performLogin() async {
    setState(() {
      isLoginPressed = true;
    });

    FirebaseUser user = await _authMethods.signIn();

    if (user != null) {
      authenticateUser(user);
    }
    setState(() {
      isLoginPressed = false;
    });
  }

  void authenticateUser(FirebaseUser user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
