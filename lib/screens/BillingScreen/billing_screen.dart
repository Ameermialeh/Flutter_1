import 'package:flutter/material.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import '../../constants/color.dart';
import 'components/billing_body.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: 'Billing Details',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BillingBody(),
            ],
          ),
        ));
  }
}
