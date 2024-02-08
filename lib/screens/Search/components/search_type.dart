class SearchType {
  SearchType({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<SearchType> type = <SearchType>[
    SearchType(
      titleTxt: 'Accounts',
      isSelected: false,
    ),
    SearchType(
      titleTxt: 'Posts',
      isSelected: false,
    ),
    SearchType(
      titleTxt: 'Offers',
      isSelected: false,
    ),
  ];
}

class RangeValue {
  double start;
  double end;

  RangeValue({
    required this.start,
    required this.end,
  });
}

List<RangeValue> price = <RangeValue>[RangeValue(start: 100, end: 600)];
