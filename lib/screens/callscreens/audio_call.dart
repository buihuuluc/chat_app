import 'dart:async';
import 'package:chat_app/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/configs/agora_configs.dart';
import 'package:chat_app/models/call.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/resources/call_methods.dart';

class AudioScreen extends StatefulWidget {
  final Call call;

  AudioScreen({
    @required this.call,
  });

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  bool _isInChannel = false;
  bool muted = false;
  static final _users = <int>[];
  final _infoStrings = <String>[];
  final CallMethods callMethods = CallMethods();
  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  int seconds = 0;
  int minute = 0;
  int hour = 0;
  Timer timer;

  /// remote user list
  final _remoteUsers = List<int>();

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    addPostFrameCallback();
    startTimer();
    joinchanel();
  }

  //Just added
  @override
  void dispose() {
    // clear users
    _users.clear();
    _stopCall();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  joinchanel() {
    _isInChannel = true;
    _toggleChannel();
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: UniversalVariables.blackColor,
  //     body: Center(
  //       child: Stack(
  //         children: <Widget>[_audioScreen(), _toolbar()],
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/call_background/a.jpeg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Stack(
            children: <Widget>[_audioScreen(), _toolbar()],
          ),
        ),
      ),
    );
  }

  Widget _audioScreen() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Calling: " +
                '$hour' +
                ':' +
                '$minute' +
                ':' +
                '$seconds'.toUpperCase(),
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
            // _checkUserList().length >= 2
            //     ? "Đang gọi:" +
            //         '$hour' +
            //         ':' +
            //         '$minute' +
            //         ':' +
            //         '$seconds'.toUpperCase()
            //     : 'Đang chờ...',
            // style: TextStyle(
            //   color: Colors.white.withOpacity(0.6),
            // ),
          ),
          SizedBox(
            height: 50,
          ),
          CachedImage(
            _users == 0 ? widget.call.callerPic : widget.call.receiverPic,
            isRound: true,
            radius: 180,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            _users == 0 ? widget.call.callerName : widget.call.receiverName,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  List<Widget> _checkUserList() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    list.length >= 2 ? _startCall() : false; //Xử lý kết thúc gọi
    return list;
  }

  void _startCall() {
    final isRunning = timer == null ? false : timer.isActive;

    isRunning ? false : startTimer();
  }

  void _stopCall() {
    timer.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
        if (seconds >= 60) {
          seconds = 0;
          minute += 1;
          if (minute >= 60) {
            hour += 1;
            minute = 0;
          }
        }
      });
    });
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userProvider.getUser.uid)
          .listen((DocumentSnapshot ds) {
        // định nghĩa logic
        switch (ds.data) {
          case null:
            // snapshot là null có nghĩa là cuộc gọi kết thúc và các dữ liệu trong db sẽ bị xóa
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? CupertinoIcons.mic_off : CupertinoIcons.mic,
              color: muted ? Colors.red : Colors.white,
              size: 40.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.black26,
            padding: const EdgeInsets.all(12.0),
          ),
          SizedBox(
            width: 50,
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(
              call: widget.call,
            ),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 40.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(APP_ID);
    AgoraRtcEngine.enableAudio();
    // AgoraRtcEngine.setParameters(
    //     '{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);

    VideoEncoderConfiguration config = VideoEncoderConfiguration();
    config.orientationMode = VideoOutputOrientationMode.FixedPortrait;
    AgoraRtcEngine.setVideoEncoderConfiguration(config);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onVideoSizeChanged = (uid, width, height, rotation) {
      print('$uid $width $height $rotation');
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _remoteUsers.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  void _toggleChannel() {
    setState(() {
      if (_isInChannel) {
        _isInChannel = true;
        AgoraRtcEngine.startPreview();
        AgoraRtcEngine.joinChannel(null, 'flutter', null, 0);
      } else {
        _isInChannel = false;
        AgoraRtcEngine.leaveChannel();
        AgoraRtcEngine.stopPreview();
      }
    });
  }

  Widget _viewColumn() {
    return Stack(children: <Widget>[
      for (final widget in _renderWidget)
        Expanded(
            child: Container(
          child: widget,
        ))
    ]);
  }

  Iterable<Widget> get _renderWidget sync* {
    yield AgoraRenderWidget(0, local: true, preview: false);

    for (final uid in _remoteUsers) {
      yield AgoraRenderWidget(uid);
    }
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildInfoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    );
  }
}
