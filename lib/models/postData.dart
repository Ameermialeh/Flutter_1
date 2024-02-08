class PostData {
  int PostID;
  String mainImg;
  String Details;
  String name;
  String city;
  double rating;
  double price;
  int subImg;

  PostData(
      {required this.PostID,
      required this.mainImg,
      required this.name,
      required this.Details,
      required this.city,
      required this.subImg,
      this.rating = 1.0,
      required this.price});
}

class Favorite {
  int id;
  int postID;
  int offerID;

  Favorite({required this.id, required this.postID, required this.offerID});
}
