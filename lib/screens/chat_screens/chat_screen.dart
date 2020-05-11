import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/utils/constants.dart';
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
  TextEditingController msgTextController = TextEditingController();
  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
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
          onPressed: () {},
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
            child: TextField(
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
                  color: Colors.white,
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
                suffixIcon: GestureDetector(
                    child: Icon(
                      MdiIcons.face,
                      color: Colors.white,
                    ),
                    onTap: () {}),
              ),
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
                  onTap: () {}),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: kFabGradient,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 15.0,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                )
              : Container(),
        ],
      ),
    );
  }

  //MessageList builder returns messageitems which uses chatLayout widget to show message
  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: 15,
      itemBuilder: (context, index) {
        return chatMessageItems();
      },
    );
  }

  Widget chatMessageItems() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.centerRight,
        child: ChatLayout(isSender: true),
      ),
    );
  }
}
