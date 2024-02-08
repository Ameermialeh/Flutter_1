class BookPostData {
  int postID;
  String name;
  String date;
  String time;
  String image;
  int price;
  bool selected;
  BookPostData(
      {required this.postID,
      required this.date,
      required this.name,
      required this.time,
      required this.image,
      required this.price,
      required this.selected});
}

class BookOfferData {
  int offerID;
  String name;
  String date;
  String time;
  String image;
  int oldPrice;
  int newPrice;
  bool selected;
  BookOfferData(
      {required this.offerID,
      required this.date,
      required this.name,
      required this.time,
      required this.image,
      required this.newPrice,
      required this.oldPrice,
      required this.selected});
}
