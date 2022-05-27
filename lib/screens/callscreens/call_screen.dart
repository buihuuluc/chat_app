import 'dart:async';
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

class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({
    @required this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isInChannel = false;
  bool muted = false;
  static final _users = <int>[];
  final _infoStrings = <String>[];
  final CallMethods callMethods = CallMethods();
  static final _sessions = List<VideoSession>();
  String dropdownValue = 'Off';
  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  /// remote user list
  final _remoteUsers = List<int>();

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    addPostFrameCallback();
    joinchanel();
  }

  //Just added
  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  joinchanel() {
    _isInChannel = true;
    _toggleChannel();
    //muted = false;
    // _onToggleMute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(children: <Widget>[
          Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: _viewColumn()),
            ],
          ),
          _toolbar(),
        ]),
      ),
    );
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
              size: 30.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.black26,
            padding: const EdgeInsets.all(12.0),
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
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              CupertinoIcons.switch_camera,
              color: Colors.white,
              size: 30.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.black26,
            padding: const EdgeInsets.all(12.0),
          )
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

    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.enableAudio();
    AgoraRtcEngine.setParameters(
        '{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
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
    return Column(
      children: <Widget>[
        for (final widget in _renderWidget)
          Expanded(
            child: Container(
              child: widget,
            ),
          )
      ],
    );
  }

  Iterable<Widget> get _renderWidget sync* {
    yield AgoraRenderWidget(0, local: true, preview: false);

    for (final uid in _remoteUsers) {
      yield AgoraRenderWidget(uid);
    }
  }

  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }

  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
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

class VideoSession {
  int uid;
  Widget view;
  int viewId;

  VideoSession(int uid, Widget view) {
    this.uid = uid;
    this.view = view;
  }
}
