// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/chat_message_body.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, required this.user});
  final Map<String, dynamic> user;
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late SharedPreferences _sharedPreferences;
  late String _userID = "";
  late String _email = "";
  late String _name = "";
  late String _image = "profile.png";
  @override
  void initState() {
    super.initState();
    getData();
    getImage();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;
    var res = await userProfile(email.trim());

    if (res['success']) {
      setState(
        () {
          _userID = res['user'][0]['id'].toString();
          _name = res['user'][0]['name'];
          _email = res['user'][0]['email'];
        },
      );
      updateMessageState();
    }
  }

  void getImage() async {
    var res = await serviceImage(widget.user['id']);

    if (res['success']) {
      setState(() {
        _image = res['user'][0]['serviceImg'];
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load the Images')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: widget.user.containsKey('id')
          ? ChatMessageBody(
              userID: _userID,
              name: _name,
              email: _email,
              image: _image,
              id: widget.user['id'])
          : const Center(child: CircularProgressIndicator()),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 65,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Row(
            children: [
              const BackButton(
                color: kPrimaryColor,
              ),
              SizedBox(
                  width: 45,
                  height: 45,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network("${Utils.baseUrl}/images/$_image"))),
              const SizedBox(width: 20 * 0.75),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user['username'],
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastActive(widget.user['last_active']),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          const Divider(color: Color(0xFFDBDADA)),
        ],
      ),
    );
  }

  String lastActive(Timestamp t) {
    Duration difference = Timestamp.now().toDate().difference(t.toDate());
    if (widget.user['is_online']) {
      return "Online now";
    }
    if (difference.inMinutes > 60) {
      if (difference.inHours > 24) {
        return "${difference.inDays} days ago";
      } else {
        return "${difference.inHours} hour ago";
      }
    } else {
      if (difference.inMinutes != 0) {
        return "${difference.inMinutes} min ago";
      } else {
        return 'Just now';
      }
    }
  }

  Future<void> updateMessageState() async {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user['id'])
        .collection('chatUsers')
        .doc(_userID)
        .collection('chat');

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await users.get() as QuerySnapshot<Map<String, dynamic>>;

    querySnapshot.docs.forEach((document) async {
      if (document.data().containsKey('messageStatus')) {
        await users.doc(document.id).update({
          'messageStatus': 'viewed',
        });
      }
    });
  }
}
