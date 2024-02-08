import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/utils.dart';
import '../../../constants/color.dart';
import 'text_messages.dart';
import 'photo_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.messageType,
    required this.isMe,
    required this.messageStatus,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String text;
  final String messageType;
  final bool isMe;
  final String messageStatus;
  final String image;
  @override
  Widget build(BuildContext context) {
    Widget messageContaint(String messageType) {
      switch (messageType) {
        case 'text':
          return TextMessage(
            text: text,
            isMe: isMe,
          );
        case 'photo':
          return PhotoMessage(imageUrl: text);
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            SizedBox(
                width: 30,
                height: 30,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network("${Utils.baseUrl}/images/$image"))),
            const SizedBox(width: 20 / 2),
          ],
          messageContaint(messageType),
          if (isMe) MessageStatusDot(status: messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final String? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(String status) {
      switch (status) {
        case 'no_con':
          return kErrorColor;
        case 'not_view':
          return Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4);
        case 'viewed':
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 20 / 2),
      height: 12,
      width: 12,
      child: Icon(
        status == 'no_con'
            ? Icons.done_outline_rounded
            : Icons.done_all_rounded,
        size: 20,
        color: dotColor(status!),
      ),
    );
  }
}
