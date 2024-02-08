class OffersData {
  int offerID;
  String mainImg;
  String details;
  String name;
  String city;
  double rating;
  double oldPrice;
  double newPrice;
  String fromDate;
  String toDate;
  int subImg;

  OffersData(
      {required this.offerID,
      required this.mainImg,
      required this.name,
      required this.details,
      required this.city,
      required this.subImg,
      this.rating = 1,
      required this.oldPrice,
      required this.newPrice,
      required this.fromDate,
      required this.toDate});
}
