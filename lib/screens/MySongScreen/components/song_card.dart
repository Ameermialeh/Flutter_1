import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';

class SongCard extends StatefulWidget {
  const SongCard(
      {super.key,
      required this.songName,
      required this.songArtist,
      required this.press});
  final String songName;
  final String songArtist;
  final VoidCallback press;
  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.songName);
    return InkWell(
      onTap: widget.press,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      '${Utils.baseUrl}/songImg/${widget.songName.split('.').first}.jpg',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songName.split('.').first.split('_').last,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.songArtist,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
