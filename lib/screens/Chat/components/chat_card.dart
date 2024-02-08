// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/constants/utils.dart';

class ChatCard extends StatefulWidget {
  final VoidCallback press;
  final Map<String, dynamic> user;
  final String userId;
  const ChatCard(
      {super.key,
      required this.press,
      required this.user,
      required this.userId});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late String _image = "profile.png";

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    var res = await serviceImage(widget.user['id']);

    if (res['success']) {
      setState(() {
        _image = res['user'][0]['serviceImg'];
      });
      print(_image);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load the Images')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20 * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            Image.network("${Utils.baseUrl}/images/$_image"))),
                if (widget.user['is_online'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user['username'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                        opacity: 0.64,
                        child: Row(
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userId)
                                  .collection('chatUsers')
                                  .doc(widget.user['id'])
                                  .collection('chat')
                                  .orderBy("createdAt", descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('');
                                }
                                var documents = snapshot.data!.docs;
                                if (documents.isEmpty) {
                                  return const Text(
                                      'No message.'); // Handle the case when no documents are available
                                }
                                RegExp urlRegExp = RegExp(r'https?://\S+');
                                var lastDocument = documents.last;
                                var stringValue = lastDocument['text'];
                                if (urlRegExp.hasMatch(stringValue)) {
                                  return const Text(
                                    'Photo',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                } else {
                                  return Text(
                                    stringValue,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .collection('chatUsers')
                  .doc(widget.user['id'])
                  .collection('chat')
                  .orderBy("createdAt", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('');
                }
                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Text(
                      'No message.'); // Handle the case when no documents are available
                }

                var lastDocument = documents.last;
                var timeValue = lastDocument['createdAt'];
                return Opacity(
                  opacity: 0.64,
                  child: Text(lastActive(timeValue)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String lastActive(Timestamp t) {
    Duration difference = Timestamp.now().toDate().difference(t.toDate());
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
}
