import 'package:flutter/material.dart';

void selectScreen(BuildContext ctx, int n) {
  if (n == 0) {
    Navigator.of(ctx).pushNamed('/notification');
  } else if (n == 1) {
    Navigator.of(ctx).pushNamed('/services');
  } else if (n == 2) {
    Navigator.of(ctx).pushNamed('/offers');
  } else if (n == 3) {
    Navigator.of(ctx).pushNamed('/updateAccount');
  } else if (n == 4) {
    Navigator.of(ctx).pushNamed('/FeedBack');
  } else if (n == 5) {
    Navigator.of(ctx).pushNamed('/billingDetails');
  } else if (n == 6) {
    Navigator.of(ctx).pushNamed('/addCard');
  } else if (n == 7) {
    Navigator.of(ctx).pushNamed('/myReservation');
  } else if (n == 8) {
    Navigator.of(ctx).pushReplacementNamed('/');
  } else if (n == 9) {
    Navigator.of(ctx).pushNamed('/myAccount');
  } else if (n == 10) {
    Navigator.of(ctx).pushNamed('/changePassword');
  } else if (n == 12) {
    Navigator.of(ctx).pushNamed('/Login');
  } else if (n == 13) {
    Navigator.of(ctx).pushNamed('/SignUp');
  } else if (n == 14) {
    Navigator.of(ctx).pushNamed('/ProfileScreen');
  } else if (n == 15) {
    Navigator.of(ctx).pushNamed('/CreateBusinessScreen');
  } else if (n == 16) {
    Navigator.of(ctx).pushNamed('/ForgetPassword');
  }
}
