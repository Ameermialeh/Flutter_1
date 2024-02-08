import 'payment_method.dart';

class userInfo {
  late String name;
  late int age;
  late String email;
  late int phoneNum;
  late String city;
  late List<payment_method> typeOfPayment;
  userInfo({
    required this.age,
    required this.city,
    required this.email,
    required this.name,
    required this.phoneNum,
    required this.typeOfPayment,
  });
}
