import 'package:flutter/material.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import '../../constants/color.dart';
import 'components/add_card_body.dart';

class AddCreditCard extends StatefulWidget {
  const AddCreditCard({super.key});

  @override
  State<AddCreditCard> createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: 'Add Card',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AddCardBody(),
            ],
          ),
        ));
  }
}
