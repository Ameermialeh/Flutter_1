class ServiceType {
  ServiceType({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<ServiceType> service_type = <ServiceType>[
    ServiceType(
      titleTxt: 'Singer',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'DJ',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'Studio',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'Decorating',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'Chair rental',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'Stage rental',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'Restaurant',
      isSelected: false,
    ),
    ServiceType(
      titleTxt: 'Organizer',
      isSelected: false,
    ),
  ];
}
