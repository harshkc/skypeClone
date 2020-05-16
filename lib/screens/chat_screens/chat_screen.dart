import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/enum/view_state.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/firebase_repositry.dart';
import 'package:skypeclone/screens/call_screens/pickups/pickup_layout.dart';
import 'package:skypeclone/utils/call_utilities.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/utils/permissions.dart';
import 'package:skypeclone/utils/utilities.dart';
import 'package:skypeclone/widgets/chat_layout.dart';
import 'package:skypeclone/widgets/custom_app_bar.dart';
import 'package:skypeclone/widgets/modal_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseRepositry _repositry = FirebaseRepositry();

  User sender;
  ImageUploadProvider _imageUploadProvider;

  TextEditingController msgTextController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  String _currentUserId;

  bool isWriting = false;
  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();

    _repositry.getCurrentUser().then((user) {
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

  // To pop and close keyboard when emoji icon is pressed
  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  toggleEmojiContainer() {
    setState(() {
      showEmojiPicker = !showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return PickupLayout(
      scaffold: Scaffold(
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15.0),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    selectedImage != null
        ?
        //To call the driver function in methods file
        _repositry.uploadImage(
            imageFile: selectedImage,
            receiverId: widget.receiver.uid,
            senderId: _currentUserId,
            imageUploadProvider: _imageUploadProvider,
          )
        : print("User returned");
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: kSeparatorColor,
      indicatorColor: kBlueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        msgTextController.text += emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "hands", "sad", "party"],
      numRecommended: 50,
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
        ),
        onTap: () {
          Navigator.maybePop(context);
        },
      ),
      centerTitle: false,
      title: Text(widget.receiver.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.videoOutline, size: 30.0),
          onPressed: () async {
            await Permissions.cameraAndMicrophonePermissionsGranted()
                ? CallUtils.dial(
                    from: sender, to: widget.receiver, context: context)
                : print("Grant the permissions");
          },
        ),
        IconButton(
          icon: Icon(MdiIcons.phoneOutline),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget chatControls() {
    //to track if user is writing something
    void setWriting(bool isLegit) {
      setState(() {
        isWriting = isLegit;
      });
    }

    //Media Modal bottom Sheet Function
    addMediaModal(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        elevation: 0.0,
        backgroundColor: kBlackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              //Content and tools tab builder
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Modal Tile List Builder
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Video",
                      icon: Icons.photo,
                      onTap: () => pickImage(source: ImageSource.gallery),
                    ),
                    ModalTile(
                      title: "Files",
                      subtitle: "Share Files",
                      icon: MdiIcons.file,
                    ),
                    ModalTile(
                      title: "Contact",
                      subtitle: "Share Contacts",
                      icon: MdiIcons.contacts,
                    ),
                    ModalTile(
                      title: "Location",
                      subtitle: "Share your Location",
                      icon: Icons.location_on,
                    ),
                    ModalTile(
                      title: "Schedule Call",
                      subtitle: "Arrange a skype call and get reminders",
                      icon: Icons.schedule,
                    ),
                    ModalTile(
                      title: "Create Poll",
                      subtitle: "Share polls",
                      icon: Icons.poll,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    //fuction used to create message object and used to call
    //repositry fuction for adding message
    void sendMessage() {
      String text = msgTextController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        type: "text",
        timeStamp: Timestamp.now(),
      );

      setState(() {
        isWriting = false;
      });

      _repositry.addMsgToDb(sender, widget.receiver, _message);
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: kFabGradient,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            onTap: () => addMediaModal(context),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: msgTextController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWriting(true)
                        : setWriting(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type your Message",
                    hintStyle: TextStyle(
                      color: kGreyColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: kSeparatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    MdiIcons.face,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (!showEmojiPicker) {
                      hideKeyboard();
                      toggleEmojiContainer();
                    } else {
                      showKeyboard();
                      toggleEmojiContainer();
                    }
                  },
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                      child:
                          Icon(MdiIcons.microphoneOutline, color: Colors.white),
                      onTap: () {}),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(MdiIcons.cameraOutline, color: Colors.white),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10.0),
                  padding: EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: kFabGradient,
                  ),
                  child: GestureDetector(
                    child: Icon(
                      MdiIcons.sendOutline,
                      size: 16.0,
                      color: Colors.white,
                    ),
                    onTap: () {
                      sendMessage();
                      msgTextController.clear();
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  //MessageList builder returns messageitems which uses chatLayout widget to show message
  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("messages")
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy("timeStamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(10.0),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return chatMessageItems(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItems(DocumentSnapshot snapshot) {
    Message message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Container(
        alignment: snapshot['senderId'] == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['senderId'] == _currentUserId
            ? ChatLayout(
                isSender: true,
                message: message,
              )
            : ChatLayout(isSender: false, message: message),
      ),
    );
  }
}
