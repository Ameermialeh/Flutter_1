class cartItem {
  int price = 0;
  String name = '';
  String description = '';
  double rating = 0;
  bool selected = false;
  String imagePath = 'assets/images/profile.png';

  cartItem({
    required this.price,
    required this.name,
    required this.description,
    required this.rating,
  });
}
