class BookBusiness {
  String userName;
  String image;
  String postName;
  String date;
  String time;
  String complete;
  int userID;
  int postID;
  int offerID;
  BookBusiness(
      {required this.postName,
      required this.userID,
      required this.postID,
      required this.offerID,
      required this.date,
      required this.userName,
      required this.time,
      required this.image,
      required this.complete});
}
