class City {
  City({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<City> city = <City>[
    City(
      titleTxt: 'Nablus',
      isSelected: false,
    ),
    City(
      titleTxt: 'Ramallah',
      isSelected: false,
    ),
    City(
      titleTxt: 'Jenin',
      isSelected: false,
    ),
    City(
      titleTxt: 'Tulkarem',
      isSelected: false,
    ),
    City(
      titleTxt: 'Jerusalem',
      isSelected: false,
    ),
    City(
      titleTxt: 'Bethlehem',
      isSelected: false,
    ),
    City(
      titleTxt: 'Hebron',
      isSelected: false,
    ),
    City(
      titleTxt: 'Jericho',
      isSelected: false,
    ),
    City(
      titleTxt: 'Qalqilya',
      isSelected: false,
    ),
    City(
      titleTxt: 'Tubas',
      isSelected: false,
    ),
    City(
      titleTxt: 'Tulkarm',
      isSelected: false,
    ),
    City(
      titleTxt: 'Salfit',
      isSelected: false,
    ),
  ];
}
