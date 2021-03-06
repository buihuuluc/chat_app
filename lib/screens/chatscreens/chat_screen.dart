import 'dart:io';

import 'package:chat_app/screens/callscreens/pickup/pickup_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_lists.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/enum/view_state.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/image_upload_provider.dart';
import 'package:chat_app/resources/auth_methods.dart';
import 'package:chat_app/screens/arcore_screen.dart';
import 'package:chat_app/screens/chatscreens/filter_screen.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:chat_app/screens/full_Image.dart';
import 'package:chat_app/utils/call_utilities.dart';
import 'package:chat_app/utils/permissions.dart';
import 'package:chat_app/utils/utilities.dart';
import 'package:chat_app/utils/universal_variables.dart';
import 'package:chat_app/widgets/appbar.dart';
import 'package:chat_app/widgets/custom_tile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/callscreens/audio_call.dart';
import 'package:chat_app/utils/audio_utilities.dart';
import 'package:chat_app/resources/chat_methods.dart';
import 'package:chat_app/resources/storage_methods.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();
  final AuthMethods _authMethods = AuthMethods();
  var vitriTinNhan = 0;

  //Tr??nh ??k scroll
  ScrollController _listScrollController = ScrollController();

  //Kh???i t???o l???p providerimage
  ImageUploadProvider _imageUploadProvider;

  User sender;

  String _currentUserId;

  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;
  bool showEmojiPicker = false;
  @override
  void initState() {
    super.initState();

    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.whiteColor,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator())
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.whiteColor,
      indicatorColor: UniversalVariables.kPrimaryColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(MESSAGES_COLLECTION)
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        // Cu???n v??? cu???i danh s??ch khi reload
        //(V?? d??? ng?????i d??ng nh???p tin nh???n n?? s??? auto cu???n v??? v??? tr?? cu???i list)
        //Nh??ng c??ng g??y m???t s??? b???t ti???n vs m???t s??? ng?????i d??ng - t???m th???i cm
        //  SchedulerBinding.instance.addPostFrameCallback((_) {
        //     _listScrollController.animateTo(
        //       _listScrollController.position.minScrollExtent,
        //       duration: Duration(milliseconds: 250),
        //       curve: Curves.easeInOut,
        //     );
        //   });

        return ListView.builder(
          padding: EdgeInsets.all(10),
          reverse: true,
          controller: _listScrollController,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            vitriTinNhan = index;
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(15);

    //Tr??? v??? kh???i tin nh???n sender
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 12),
          constraints:
              // ??o???n n??y gi??? cho ??o???n tin nh???n kh??ng v?????t qu?? gi?? tr??? <??? ????y l?? 65% m??n h??nh>
              BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65),
          decoration: BoxDecoration(
            color: UniversalVariables.kPrimaryColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: messageRadius,
              topRight: messageRadius,
              bottomLeft: messageRadius,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: getMessage(message),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(partTime(message.timestamp),
              style:
                  TextStyle(color: UniversalVariables.greyColor, fontSize: 12)
              // message.timestamp.toDate().month.toString()
              ),
        ),
      ],
    );
  }

  //Ph????ng th???c n??y ????? l???y d??? li???u tin nh???n t??? user nh???p th??ng qua DB
  getMessage(Message message) {
    return message.type != MESSAGE_TYPE_IMAGE
        ? Text(
            message != null ? message.message : "",
            style: TextStyle(
              color: UniversalVariables.blackColor,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null
            ? GestureDetector(
                child: CachedImage(
                  message.photoUrl,
                  width: 250,
                  height: 200,
                  radius: 5,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullImageScreen(photoUrl: message.photoUrl)));
                },
              )
            : Text('No picture');
  }

  // Widget b??? c???c tin nh???n ph??a ng?????i nh???n
  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(15);
    bool flag = null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          // onDoubleTap: (){},
          child: Container(
            margin: EdgeInsets.only(top: 12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65),
            decoration: BoxDecoration(
              color: UniversalVariables.greyColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                bottomRight: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: getMessage(message),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(partTime(message.timestamp),
              style:
                  TextStyle(color: UniversalVariables.greyColor, fontSize: 12)
              // message.timestamp.toDate().month.toString()
              ),
        ),
      ],
    );
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  //Widget chatcontrol
  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    //c???u h??nh container th??m c??c Media v??o h???i tho???i
    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.whiteColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "PH????NG TH???C G???I",
                            style: TextStyle(
                                color: UniversalVariables.blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "???nh",
                        subtitle: "Chia s??? ???nh th?? vi???n",
                        icon: Icons.image,
                        onTap: () => pickImage(source: ImageSource.gallery),
                      ),
                      ModalTile(
                        title: "Camera",
                        subtitle: "Truy c???p camera",
                        icon: Icons.camera_alt,
                        onTap: () => pickImage(source: ImageSource.camera),
                      ),
                      ModalTile(
                          title: "DeepAR",
                          subtitle: "Truy c???p camera DeepAR",
                          icon: CupertinoIcons.wand_stars,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilterScreen()));
                          }),
                      ModalTile(
                          title: "ARCore",
                          subtitle: "M?? h??nh ARCore",
                          icon: Icons.adb,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          }),
                      ModalTile(
                          title: "L???ch",
                          subtitle: "S???p x???p m???t cu???c g???i v?? nh???n l???i nh???c",
                          icon: Icons.schedule),
                      ModalTile(
                          title: "V??? tr??",
                          subtitle: "G???i v??? tr?? hi???n t???i",
                          icon: Icons.pin_drop)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() {
      var text = textFieldController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      textFieldController.text = "";

      _chatMethods.addMessageToDb(_message);
    }

    //Widget ??i???u khi???n thanh chat
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: UniversalVariables.kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: UniversalVariables.whiteColor,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () {
                    hideEmojiContainer();
                  },
                  style: TextStyle(color: UniversalVariables.blackColor),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Nh???p tin nh???n...",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide(
                            color: UniversalVariables.inputColor, width: 0.5)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.whiteColor,
                  ),
                ),
                // Icon Smile
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(
                    CupertinoIcons.smiley_fill,
                    color: showEmojiPicker
                        ? UniversalVariables.smileEmojiColor
                        : UniversalVariables.greyColor,
                  ),
                ),
              ],
            ),
          ),
          // Send button
          Container(
              width: 46,
              height: 46,
              margin: EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: UniversalVariables.kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 15,
                  color: UniversalVariables.whiteColor,
                ),
                onPressed: () => sendMessage(),
              ))
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: SizedBox(
          height: 20,
          width: 20,
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Row(
        children: [
          CachedImage(
            widget.receiver.profilePhoto,
            height: 40,
            width: 40,
            isRound: true,
            radius: 40,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.receiver.name,
            style: TextStyle(
                fontFamily: UniversalVariables.defaultFont, fontSize: 16),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            CupertinoIcons.video_camera,
            size: 30,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(
                      from: sender, to: widget.receiver, context: context)
                  : {},
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.phone,
            size: 25,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? AudioUtils.dial(
                      from: sender, to: widget.receiver, context: context)
                  : {},
        )
      ],
    );
  }

  String partTime(Timestamp time) {
    var day = time.toDate().day.toString();
    var month = time.toDate().month.toString();
    var year = time.toDate().year.toString();
    var h = time.toDate().hour.toString();
    var p = time.toDate().minute.toString();
    var s = time.toDate().second.toString();
    // String a = 'Ng??y '+ day + '/' + month + '/' + year + ' | '+h+':'+p;
    String a = h + ':' + p;
    return a;
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {@required this.title,
      @required this.subtitle,
      @required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CustomTile(
          mini: false,
          onTap: onTap,
          leading: Container(
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: UniversalVariables.kPrimaryColor,
            ),
            padding: EdgeInsets.all(10),
            child: Icon(
              icon,
              color: UniversalVariables.whiteColor,
              size: 38,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontSize: 14,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: UniversalVariables.blackColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
