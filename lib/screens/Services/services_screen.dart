import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/models/services.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import 'components/services_cart.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: 'All Services',
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shrinkWrap: true,
                    itemBuilder: (_, int index) {
                      return ServicesCard(
                        service: ServicesList[index],
                      );
                    },
                    itemCount: ServicesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
