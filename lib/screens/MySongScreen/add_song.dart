// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/add_song_api.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class AddSong extends StatefulWidget {
  const AddSong({super.key});

  @override
  State<AddSong> createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  late SharedPreferences _sharedPreferences;
  final TextEditingController _songName = TextEditingController();
  late FilePickerResult? result;
  String name = '';
  int businessID = 0;
  File? _pickedImageFile;
  String base64 = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessID = _sharedPreferences.getInt('Business_Id')!;
    });
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    base64 = await imageToBase64(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarAll(appBarName: 'Add Song'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _pickedImageFile == null
                            ? Image.asset('assets/images/SongLogo.jpeg')
                            : Image.file(_pickedImageFile!),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 18,
                        child: GestureDetector(
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
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Name of Song: ',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    style: const TextStyle(fontSize: 18),
                    controller: _songName,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose Song: ',
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      uploadAudio();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60))),
                    child: const Text(
                      'Choose Song',
                      style: TextStyle(fontSize: 20, color: kPrimaryLight),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_songName.text.isNotEmpty &&
                            businessID != 0 &&
                            base64.isNotEmpty) {
                          addSong(
                              _songName.text.toString(), businessID, base64);
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("All Fields are require.")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      child: const Text(
                        'Add New Song',
                        style: TextStyle(fontSize: 20, color: kPrimaryLight),
                      )),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  void uploadAudio() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
      withData: true,
    );
    if (result == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File pick canceled.")),
      );
    } else {
      setState(() {
        name = result!.files.first.name;
      });
    }
  }

  addSong(String name, int businessID, String image) async {
    if (result != null && result!.files.isNotEmpty) {
      var platformFile = result!.files.first;
      var fileBytes = await platformFile.bytes!.toList();
      String fileExtension = result!.paths.first!.split('.').last;
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Utils.baseUrl}/user/uploadAudio'),
        );
        request.fields['songName'] = name;
        request.fields['userID'] = businessID.toString();
        request.fields['fileExtension'] = fileExtension;

        request.files.add(http.MultipartFile.fromBytes(
          'audioFile',
          fileBytes,
          filename: platformFile.name,
          contentType: MediaType('audio', fileExtension),
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          String ext = '${businessID}_$name.$fileExtension';
          var resPhoto = await uploadSongImg(ext.split('.').first, base64);
          var res = await addNewSong(businessID, ext);

          if (res['success'] && resPhoto['success']) {
            print('here');
            QuickAlert.show(
              animType: QuickAlertAnimType.scale,
              context: context,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              type: QuickAlertType.success,
              text: 'Song added successfully.',
            );
          } else {
            print('Failed to upload audio to db or upload image to server');
          }
        } else {
          QuickAlert.show(
            animType: QuickAlertAnimType.scale,
            context: context,
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
            },
            type: QuickAlertType.error,
            text: 'Failed to upload audio.',
          );
        }
      } catch (e) {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          type: QuickAlertType.error,
          text: 'Error uploading audio.',
        );
      }
    } else {
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
        type: QuickAlertType.error,
        text: 'Please choose Song',
      );
    }
  }
}
