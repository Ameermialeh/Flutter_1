// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/add_song_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/models/songData.dart';
import 'package:gp1_flutter/screens/MySongScreen/add_song.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import '../CardServices/song.dart';
import 'components/song_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySongScreen extends StatefulWidget {
  const MySongScreen({super.key});

  @override
  State<MySongScreen> createState() => _MySongScreenState();
}

class _MySongScreenState extends State<MySongScreen> {
  late SharedPreferences _sharedPreferences;
  late int businessID = 0;
  late String businessName = '';
  List<SongData> mySong = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessID = _sharedPreferences.getInt('Business_Id')!;
      businessName = _sharedPreferences.getString('Business_name')!;
    });

    var res = await getMySong(businessID);
    if (res['success']) {
      for (var i in res['song']!) {
        SongData data = SongData(name: i['song_path']);
        setState(() {
          mySong.add(data);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Stack(
            children: [
              const AppBarAll(appBarName: 'My Songs'),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.80,
                top: MediaQuery.of(context).size.height * 0.045,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const AddSong();
                        },
                      ));
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 35,
                    )),
              )
            ],
          )),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: mySong.isNotEmpty
            ? SizedBox(
                height: 80.toDouble() * mySong.length,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 3));
                    setState(() {
                      mySong = [];
                    });
                    getData();
                  },
                  child: ListView.builder(
                    itemCount: mySong.length,
                    itemBuilder: (context, index) {
                      return SongCard(
                        press: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Song(
                                songName: mySong[index].name,
                              );
                            },
                          ));
                        },
                        songName: mySong[index].name,
                        songArtist: businessName,
                      );
                    },
                  ),
                ),
              )
            : const Center(child: Text('No Song for Now')),
      )),
    );
  }
}
