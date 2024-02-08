import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/book.dart';
import 'size_config.dart';

class BookTile extends StatelessWidget {
  const BookTile({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: bluishClr),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.network(
                      "${Utils.baseUrl}/mainImg/${book.image}",
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.businessName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              book.postName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.grey[200],
                                  size: 25,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  book.time,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 0.5,
                      width: MediaQuery.of(context).size.width * 0.7,
                      color: Colors.grey[200]!.withOpacity(0.7),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (book.complete == 'waiting')
                      const Text(
                        'Waiting',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 230, 0),
                            fontSize: 20),
                      )
                    else if (book.complete == 'Confirmed')
                      const Text(
                        'Confirmed',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 235, 8),
                            fontSize: 20),
                      )
                    else
                      const Text(
                        'Canceled',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 17, 0),
                            fontSize: 20),
                      ),
                  ],
                )
              ],
            ),
          ),
          if (book.complete == 'waiting' || book.complete == 'confirmed')
            Positioned(
                left: MediaQuery.of(context).size.width * 0.73,
                top: MediaQuery.of(context).size.height * 0.15,
                child: TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.red),
                                      )),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                      size: 30,
                    ),
                    label: const Text('')))
        ],
      ),
    );
  }
}
