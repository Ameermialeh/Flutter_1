// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import '../../constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/chat_body_search.dart';

class BusinessChat extends StatefulWidget {
  const BusinessChat({super.key});

  @override
  State<BusinessChat> createState() => _BusinessChatState();
}

class _BusinessChatState extends State<BusinessChat> {
  late SharedPreferences _sharedPreferences;
  late int _id = 0;
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
          preferredSize: const Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Chat",
                  style: TextStyle(fontSize: 25, color: kPrimaryColor),
                ),
                GestureDetector(
                  onTap: _toggleSearch,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isSearchActive ? 250 : 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: _isSearchActive ? 10 : 0),
                          child: const Icon(Icons.search, color: Colors.black),
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
        body: _id != 0
            ? StreamBuilder<String>(
                stream: _textController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String text = snapshot.data!;
                    return ChatBodySearchBusiness(
                        id: _id.toString(), planText: text);
                  } else {
                    return ChatBodySearchBusiness(
                        id: _id.toString(), planText: '');
                  }
                },
              )
            : const Text(''));
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      _id = _sharedPreferences.getInt("Business_Id")!;
    });
  }
}
