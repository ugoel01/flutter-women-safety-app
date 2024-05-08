import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/msg_textField.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/myMessage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatWindow extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;

  const ChatWindow({super.key,
    required this.currentUserId,
    required this.friendId,
    required this.friendName});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  String? type;
  String? myname;

  getStatus() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .get()
        .then((value) {
      setState(() {
        type = value.data()!['type'];
        myname = value.data()!['name'];
      });
    });
  }

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text(widget.friendName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUserId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: ListView.builder(
                      reverse: true, // Key change for scrolling to bottom
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isMe = snapshot.data!.docs[index]['senderId'] == widget.currentUserId;
                        final data = snapshot.data!.docs[index];
                        return Dismissible(
                          key: UniqueKey(),
                            onDismissed: (direction) async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.currentUserId)
                                  .collection('messages')
                                  .doc(widget.friendId)
                                  .collection('chats')
                                  .doc(data.id)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.friendId)
                                  .collection('messages')
                                  .doc(widget.currentUserId)
                                  .collection('chats')
                                  .doc(data.id)
                                  .delete()
                                  .then((value) => Fluttertoast.showToast(
                                      msg: 'message deleted successfully'));
                            },
                          child: MyMessage(
                            message: data['message'],
                            date: data['date'],
                            isMe: isMe,
                            friendName: widget.friendName,
                            myName: myname,
                            type: data['type'],
                          ),
                        );
                      },
                    ),
                  );
                }
                return loadingWheel(context);
              },
            ),
          ),
          MessageTextField(
            currentId: widget.currentUserId,
            friendId: widget.friendId,
          )
        ],
      ),
    );
  }
}
