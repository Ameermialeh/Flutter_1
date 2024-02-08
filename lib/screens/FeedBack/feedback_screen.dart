import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'components/feedback_body.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({super.key, required this.id});

  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarAll(
          appBarName: 'FeedBack',
        ),
      ),
      body: SingleChildScrollView(
        child: FeedBackBody(
          id: id,
        ),
      ),
    );
  }
}
