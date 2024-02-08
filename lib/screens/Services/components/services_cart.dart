import 'package:flutter/material.dart';

import '../../../constants/size.dart';
import '../../../models/services.dart';
import '../../one_service_screen.dart';

class ServicesCard extends StatelessWidget {
  final Services service;

  const ServicesCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceScreen(
            service: service,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              service.thumbnail,
              height: kCategoryCardImageSize,
            ),
            const SizedBox(height: 10),
            Text(
              service.name,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
