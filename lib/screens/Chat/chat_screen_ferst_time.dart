// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/chat_message_body.dart';

class MessagesScreenView extends StatefulWidget {
  const MessagesScreenView({super.key, required this.user});
  final Map<String, dynamic> user;
  @override
  State<MessagesScreenView> createState() => _MessagesScreenViewState();
}

class _MessagesScreenViewState extends State<MessagesScreenView> {
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
    }
  }

  void getImage() async {
    var res = await serviceImage(widget.user['id'].toString());

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
              id: widget.user['id'].toString())
          : const Center(child: CircularProgressIndicator()),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(
            color: kPrimaryLight,
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
            ],
          )
        ],
      ),
    );
  }
}
