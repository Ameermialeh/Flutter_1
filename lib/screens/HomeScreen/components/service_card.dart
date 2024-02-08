import 'package:flutter/material.dart';
import '../../../constants/size.dart';
import '../../../models/services.dart';
import '../../one_service_screen.dart';

class ServiceCard extends StatelessWidget {
  final Services service;
  const ServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceScreen(service: service),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              service.thumbnail,
              height: kCategoryCardImageSize,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                service.name,
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
