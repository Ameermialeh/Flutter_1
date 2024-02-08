import 'package:gp1_flutter/screens/Chat/messages_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_card.dart';

class ChatBodySearch extends StatefulWidget {
  final String id;
  final String planText;
  const ChatBodySearch({super.key, required this.id, required this.planText});

  @override
  State<ChatBodySearch> createState() => _ChatBodySearchState();
}

class _ChatBodySearchState extends State<ChatBodySearch> {
  late List<Map<String, dynamic>> mapData = [];
  bool isLoading = true;
  bool noChat = false;
  @override
  void initState() {
    super.initState();

    _getchatUsers(widget.id).then(
      (List<int> res) {
        print('res: $res');
        for (var i = 0; i < res.length; i++) {
          FirebaseFirestore.instance
              .collection('services')
              .doc(res[i].toString())
              .get()
              .then((value) {
            setState(() {
              if (value.data() != null) {
                mapData.add(value.data()!);
              }
              isLoading = false;
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: isLoading && noChat
                ? const Center(child: Text(''))
                : isLoading
                    ? const Center(
                        child: Text('', style: TextStyle(fontSize: 30)))
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.id)
                            .collection('chatUsers')
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(child: Text(''));
                            case ConnectionState.active:
                            case ConnectionState.done:
                              List<Map<String, dynamic>> mapDataSearch = [];

                              for (var i in mapData) {
                                if (i['username']
                                    .toString()
                                    .toLowerCase()
                                    .contains(widget.planText.toLowerCase())) {
                                  mapDataSearch.add(i);
                                }
                              }
                              if (mapDataSearch.isEmpty) {
                                mapDataSearch = mapData;
                              }

                              return ListView.builder(
                                  itemCount: mapDataSearch.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    String sanitizedInput = mapDataSearch[index]
                                            ['username']
                                        .toString();
                                    if (widget.planText == '') {
                                      return ChatCard(
                                        press: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MessagesScreen(
                                                    user: mapDataSearch[index]),
                                          ),
                                        ),
                                        user: mapDataSearch[index],
                                        userId: widget.id,
                                      );
                                    } else if (sanitizedInput
                                        .toLowerCase()
                                        .contains(
                                            widget.planText.toLowerCase())) {
                                      return ChatCard(
                                        press: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MessagesScreen(
                                                    user: mapDataSearch[index]),
                                          ),
                                        ),
                                        user: mapDataSearch[index],
                                        userId: widget.id,
                                      );
                                    } else {
                                      return null;
                                    }
                                  });
                          }
                        },
                      )),
      ],
    );
  }

  Future<List<int>> _getchatUsers(String id) async {
    List<int> idUser = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('chatUsers')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.id);
        idUser.add(int.parse(element.id));
      });
    });
    if (idUser.isEmpty) {
      setState(() => noChat = true);
    }
    return idUser;
  }
}
