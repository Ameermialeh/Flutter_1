import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/utils.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.date,
      required this.image});
  final String name;
  final String subtitle;
  final String date;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 30),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 15),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network("${Utils.baseUrl}/images/$image")),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 210),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                                color: Color.fromARGB(150, 0, 0, 0)),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(150, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
