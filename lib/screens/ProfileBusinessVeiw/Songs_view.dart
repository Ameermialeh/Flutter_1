import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/add_song_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/models/songData.dart';
import 'package:gp1_flutter/screens/CardServices/song.dart';
import 'package:gp1_flutter/screens/MySongScreen/components/song_card.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

class SongView extends StatefulWidget {
  const SongView(
      {super.key, required this.businessID, required this.businessName});
  final int businessID;
  final String businessName;
  @override
  State<SongView> createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  List<SongData> song = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var res = await getMySong(widget.businessID);
    if (res['success']) {
      for (var i in res['song']!) {
        SongData data = SongData(name: i['song_path']);
        setState(() {
          song.add(data);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(appBarName: 'Songs')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: song.isNotEmpty
            ? SizedBox(
                height: 80.toDouble() * song.length,
                child: ListView.builder(
                  itemCount: song.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SongCard(
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Song(
                              songName: song[index].name,
                            );
                          },
                        ));
                      },
                      songName: song[index].name,
                      songArtist: widget.businessName,
                    );
                  },
                ),
              )
            : const Center(child: Text('No Song for Now')),
      )),
    );
  }
}
