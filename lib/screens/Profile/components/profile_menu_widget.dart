import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.textColor,
    this.endIcon = true,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? textColor;
  final bool endIcon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black.withOpacity(0.1)),
        child: Icon(
          icon,
          size: 30,
          color: Colors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20, color: textColor, fontWeight: FontWeight.w500),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.black,
              ),
            )
          : null,
    );
  }
}
