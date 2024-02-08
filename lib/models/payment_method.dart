enum Type_of_method {
  visa,
  masterCard,
  cash,
}

class payment_method {
  late int numOfPayment;
  late int cvv;
  late Type_of_method type;

  payment_method(
    int index1, {
    required this.cvv,
    required this.numOfPayment,
    required this.type,
  });
}
