class Services {
  String thumbnail;
  String name;

  Services({
    required this.name,
    required this.thumbnail,
  });
}

List<Services> ServicesList = [
  Services(
    name: 'Singer',
    thumbnail: 'assets/images/singer.png',
  ),
  Services(
    name: 'DJ',
    thumbnail: 'assets/images/DJ.png',
  ),
  Services(
    name: 'Studio',
    thumbnail: 'assets/images/studio.png',
  ),
  Services(
    name: 'Decorating ',
    thumbnail: 'assets/images/decorating.png',
  ),
  Services(
    name: 'Chair rental ',
    thumbnail: 'assets/images/chair.png',
  ),
  Services(
    name: 'Stage rental',
    thumbnail: 'assets/images/stage.png',
  ),
  Services(
    name: 'Restaurant',
    thumbnail: 'assets/images/restaurant.png',
  ),
  Services(
    name: 'Organize the party activities',
    thumbnail: 'assets/images/staff.png',
  ),
];
