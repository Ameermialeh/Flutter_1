// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/screens/Chat/components/chat_body_search.dart';
import '../../constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late SharedPreferences _sharedPreferences;
  late String _id = '';
  bool _isSearchActive = false;

  final StreamController<String> _textController = StreamController<String>();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _textController.close();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
    });
    if (!_isSearchActive) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5],
                colors: [
                  Color(0xFFE98566),
                  Color(0xFFFD784F),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                GestureDetector(
                  onTap: _toggleSearch,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isSearchActive ? 250 : 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPrimaryLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: _isSearchActive ? 10 : 0),
                          child: const Icon(Icons.search, color: Colors.grey),
                        ),
                        _isSearchActive
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: TextField(
                                  autofocus: true,
                                  focusNode: _focusNode,
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search by name ...",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  onChanged: (value) {
                                    _textController.add(value);
                                  },
                                ),
                              ))
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _id.isNotEmpty
            ? StreamBuilder<String>(
                stream: _textController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String text = snapshot.data!;
                    return ChatBodySearch(id: _id, planText: text);
                  } else {
                    return ChatBodySearch(id: _id, planText: '');
                  }
                },
              )
            : const Text(''));
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;
    var res = await userProfile(email.trim());

    if (res['success']) {
      setState(
        () {
          while (true) {
            if (_id != '') break;
            _id = res['user'][0]['id'].toString();
          }
        },
      );
    }
  }
}
