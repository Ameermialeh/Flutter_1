import 'package:flutter/material.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import '../../constants/color.dart';
import 'components/create_business_body.dart';

class CreateBusinessScreen extends StatelessWidget {
  const CreateBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarAll(
          appBarName: 'Create Business Account',
        ),
      ),
      body: SingleChildScrollView(
        child: CreateBusinessBody(),
      ),
    );
  }
}
