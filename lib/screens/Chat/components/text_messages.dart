import 'package:flutter/material.dart';

import '../../../constants/color.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.text,
    required this.isMe,
  }) : super(key: key);
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20 * 0.75,
        vertical: 20 / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(isMe ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      constraints: const BoxConstraints(maxWidth: 200),
      child: Text(
        text,
        style: TextStyle(
          height: 1.3,
          color: isMe
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge!.color,
        ),
        softWrap: true,
      ),
    );
  }
}
