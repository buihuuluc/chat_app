import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/enum/user_state.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/resources/local_db/repository/log_repository.dart';
import 'package:chat_app/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chat_app/screens/pageviews/chats/chat_list_screen.dart';
import 'package:chat_app/screens/pageviews/logs/log_screen.dart';
import 'package:chat_app/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;

  final AuthMethods _authMethods = AuthMethods();
  // final LogRepository _logRepository = LogRepository(isHive: true);
  // final LogRepository _logRepository = LogRepository(isHive: false);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );

      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          children: <Widget>[
            ChatListScreen(),
            LogScreen(),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.kPrimaryColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        fontFamily: UniversalVariables.defaultFont,
                        color: (_page == 0)
                            ? UniversalVariables.kPrimaryColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: (_page == 1)
                          ? UniversalVariables.kPrimaryColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Call Logs",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        fontFamily: UniversalVariables.defaultFont,
                        color: (_page == 1)
                            ? UniversalVariables.kPrimaryColor
                            : UniversalVariables.greyColor),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
