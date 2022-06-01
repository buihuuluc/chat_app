import 'package:chat_app/utils/universal_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/utilities.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameControl = new TextEditingController();
  final companyControl = new TextEditingController();
  final emailControl = new TextEditingController();
  final addControl = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final phoneControl = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameControl,
        keyboardType: TextInputType.name,
        cursorColor: UniversalVariables.greyColor,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value.isEmpty) {
            return ("Tên không được để trống");
          }
          if (!regex.hasMatch(value)) {
            return ("Tên tối thiểu 3 ký tự");
          }
          return null;
        },
        onSaved: (value) {
          nameControl.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nhập tên...",
          focusColor: UniversalVariables.kPrimaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //add field
    final addField = TextFormField(
        autofocus: false,
        controller: addControl,
        keyboardType: TextInputType.streetAddress,
        cursorColor: UniversalVariables.greyColor,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value.isEmpty) {
            return ("Tên không được để trống");
          }
          if (!regex.hasMatch(value)) {
            return ("Tên tối thiểu 3 ký tự");
          }
          return null;
        },
        onSaved: (value) {
          addControl.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            CupertinoIcons.location,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nhập địa chỉ...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //company field
    final companyField = TextFormField(
        autofocus: false,
        controller: companyControl,
        keyboardType: TextInputType.name,
        cursorColor: UniversalVariables.greyColor,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value.isEmpty) {
            return ("Tên không được để trống");
          }
          if (!regex.hasMatch(value)) {
            return ("Tên tối thiểu 3 ký tự");
          }
          return null;
        },
        onSaved: (value) {
          companyControl.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.work,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nhập tên công ty...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //phone field
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneControl,
        keyboardType: TextInputType.phone,
        cursorColor: UniversalVariables.greyColor,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value.isEmpty) {
            return ("Tên không được để trống");
          }
          if (!regex.hasMatch(value)) {
            return ("Tên tối thiểu 3 ký tự");
          }
          return null;
        },
        onSaved: (value) {
          phoneControl.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nhập số điện thoại...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailControl,
        keyboardType: TextInputType.emailAddress,
        cursorColor: UniversalVariables.greyColor,
        validator: (value) {
          if (value.isEmpty) {
            return ("Vui lòng nhập Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Email không hợp lệ !");
          }
          return null;
        },
        onSaved: (value) {
          emailControl.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        cursorColor: UniversalVariables.greyColor,
        obscureText: true,
        // ignore: missing_return
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          // firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        cursorColor: UniversalVariables.greyColor,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: UniversalVariables.kPrimaryColor,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: UniversalVariables.kPrimaryColor,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailControl.text, passwordEditingController.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: UniversalVariables.kPrimaryColor),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: UniversalVariables.whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 210,
                        child: Image.asset(
                          "assets/logo/new_chat_Sigup_logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 25),
                    nameField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    addField,
                    SizedBox(height: 20),
                    companyField,
                    SizedBox(height: 20),
                    phoneField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e.message);
        });
      } on AuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    Firestore firebaseFirestore =
        Firestore.instance; // bản mới FireBase FireStore
    // User user = _auth.currentUser; pb mới
    final FirebaseUser user = await _auth.currentUser();

    User userModel = User();

    // Truyền tham số từ form vào biến
    userModel.add = addControl.text;
    userModel.company = companyControl.text;
    userModel.uid = user.uid; //Auto generated
    userModel.name = nameControl.text;
    userModel.email = user.email;
    userModel.phone = phoneControl.text;
    userModel.username = Utils.getUsername(user.email);
    userModel.status = '1';
    userModel.state = 1;
    userModel.profilePhoto =
        'https://banner2.cleanpng.com/20190123/jtv/kisspng-computer-icons-vector-graphics-person-portable-net-myada-baaranmy-teknik-servis-hizmetleri-5c48d5c2849149.051236271548277186543.jpg';

    await firebaseFirestore
        .collection("users")
        .document(user.uid)
        .setData(userModel.toMap(userModel));
    Fluttertoast.showToast(msg: "Đăng ký tài khoản thành công !!");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
