import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/screens/Chat/components/message.dart';

import 'chat_input_filed.dart';

class ChatMessageBody extends StatelessWidget {
  const ChatMessageBody(
      {Key? key,
      required this.userID,
      required this.email,
      required this.name,
      required this.id,
      required this.image})
      : super(key: key);
  final String userID;
  final String email;
  final String name;
  final String id;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder(
              stream: id.isNotEmpty && userID.isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .doc(userID)
                      .collection('chatUsers')
                      .doc(id)
                      .collection('chat')
                      .orderBy("createdAt", descending: true)
                      .snapshots()
                  : null,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages found,\n   Send a message',
                          style: TextStyle(fontSize: 28),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong ...'),
                      );
                    }
                    final loadedMessages = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 10, right: 10),
                      reverse: true,
                      itemCount: loadedMessages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currentMessageUserName =
                            loadedMessages[index].data()['username'];
                        final currentMessageUserEmail =
                            loadedMessages[index].data()['userEmail'];

                        return Message(
                            messageType:
                                loadedMessages[index].data()['messageType'],
                            isMe: currentMessageUserName == name &&
                                currentMessageUserEmail == email,
                            messageStatus: loadedMessages[index]
                                    .data()
                                    .containsKey('messageStatus')
                                ? loadedMessages[index].data()['messageStatus']
                                : 'notFound',
                            image: image,
                            text: loadedMessages[index].data()['text']);
                      },
                    );
                }
              },
            ),
          ),
        ),
        ChatInputField(userID: userID, name: name, email: email, id: id),
      ],
    );
  }
}
