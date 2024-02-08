import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInputFieldBusiness extends StatefulWidget {
  final String userID;
  final String email;
  final String name;
  final String id;
  const ChatInputFieldBusiness(
      {super.key,
      required this.userID,
      required this.email,
      required this.name,
      required this.id});

  @override
  State<ChatInputFieldBusiness> createState() => _ChatInputFieldBusinessState();
}

class _ChatInputFieldBusinessState extends State<ChatInputFieldBusiness> {
  final _messageController = TextEditingController();
  List<File?> _pickedImageFile = [];
  bool _visiblePhoto = false;

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _sendMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty && _pickedImageFile.isEmpty) {
      return;
    }
    if (enteredMessage.trim().isNotEmpty && _pickedImageFile.isEmpty) {
      if (widget.id.isNotEmpty && widget.userID.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('services')
            .doc(widget.userID)
            .collection('chatUsers')
            .doc(widget.id)
            .collection('chat')
            .add({
          'text': enteredMessage,
          'createdAt': Timestamp.now(),
          'userId': widget.userID,
          'messageStatus': 'not_view',
          'userEmail': widget.email,
          'username': widget.name,
          'messageType': 'text'
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .collection('chatUsers')
            .doc(widget.userID)
            .collection('chat')
            .add({
          'text': enteredMessage,
          'createdAt': Timestamp.now(),
          'userId': widget.userID,
          'userEmail': widget.email,
          'username': widget.name,
          'messageType': 'text'
        });
      }
      //
      FocusScope.of(context).unfocus();
      _messageController.clear();
    }

    if (enteredMessage.trim().isNotEmpty && _pickedImageFile.isNotEmpty) {
      //photo
      for (var i in _pickedImageFile) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('chat_images')
            .child('${widget.userID}-${Random().nextInt(100) + 50}.jpg');
        await storageRef.putFile(i!);
        final imageUrl = await storageRef.getDownloadURL();
        if (widget.id.isNotEmpty && widget.userID.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('services')
              .doc(widget.userID)
              .collection('chatUsers')
              .doc(widget.id)
              .collection('chat')
              .add({
            'text': imageUrl,
            'createdAt': Timestamp.now(),
            'userId': widget.userID,
            'messageStatus': 'not_view',
            'userEmail': widget.email,
            'username': widget.name,
            'messageType': 'photo'
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              .collection('chatUsers')
              .doc(widget.userID)
              .collection('chat')
              .add({
            'text': imageUrl,
            'createdAt': Timestamp.now(),
            'userId': widget.userID,
            'userEmail': widget.email,
            'username': widget.name,
            'messageType': 'photo'
          });

          //text
          await FirebaseFirestore.instance
              .collection('services')
              .doc(widget.userID)
              .collection('chatUsers')
              .doc(widget.id)
              .collection('chat')
              .add({
            'text': enteredMessage,
            'createdAt': Timestamp.now(),
            'userId': widget.userID,
            'messageStatus': 'not_view',
            'userEmail': widget.email,
            'username': widget.name,
            'messageType': 'text'
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              .collection('chatUsers')
              .doc(widget.userID)
              .collection('chat')
              .add({
            'text': enteredMessage,
            'createdAt': Timestamp.now(),
            'userId': widget.userID,
            'userEmail': widget.email,
            'username': widget.name,
            'messageType': 'text'
          });
        }
      }
      //
      FocusScope.of(context).unfocus();
      _messageController.clear();
      //
      setState(() {
        _pickedImageFile = [];
      });
    }

    if (enteredMessage.trim().isEmpty && _pickedImageFile.isNotEmpty) {
      for (var i in _pickedImageFile) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('chat_images')
            .child('${widget.userID}-${Random().nextInt(100) + 50}.jpg');
        await storageRef.putFile(i!);
        final imageUrl = await storageRef.getDownloadURL();

        if (widget.id.isNotEmpty && widget.userID.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('services')
              .doc(widget.userID)
              .collection('chatUsers')
              .doc(widget.id)
              .collection('chat')
              .add({
            'text': imageUrl,
            'createdAt': Timestamp.now(),
            'userId': widget.userID,
            'messageStatus': 'not_view',
            'userEmail': widget.email,
            'username': widget.name,
            'messageType': 'photo'
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              .collection('chatUsers')
              .doc(widget.userID)
              .collection('chat')
              .add({
            'text': imageUrl,
            'createdAt': Timestamp.now(),
            'userId': widget.userID,
            'userEmail': widget.email,
            'username': widget.name,
            'messageType': 'photo'
          });
        }
      }
      setState(() {
        _pickedImageFile = [];
      });
    }
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile.add(File(pickedImage.path));
      _visiblePhoto = false;
    });
  }

  void _takeImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile.add(File(pickedImage.path));
      _visiblePhoto = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Visibility(
                      visible: _pickedImageFile.isNotEmpty,
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 24,
                        ),
                        itemBuilder: (context, index) {
                          return Image.file(_pickedImageFile[index]!);
                        },
                        itemCount: _pickedImageFile.length,
                      ),
                    ),
                    Visibility(
                      visible: _visiblePhoto,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => _takeImage(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: kPrimaryColor),
                                  child: const Icon(
                                    Icons.camera_alt,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _pickImage(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: kPrimaryColor),
                                  child: const Icon(
                                    Icons.photo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Camera'),
                              Text('Album'),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _visiblePhoto = !_visiblePhoto;
                            });
                          },
                          icon: const Icon(Icons.photo),
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.64),
                        ),
                        const SizedBox(width: 20 / 4),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: "Type message",
                              border: InputBorder.none,
                            ),
                            autocorrect: true,
                            enableSuggestions: true,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.send),
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.64),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
