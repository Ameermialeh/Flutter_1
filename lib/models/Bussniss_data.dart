class BusinessData {
  String serviceId;
  String serviceName;
  String serviceType;
  String serviceCity;
  String serviceImg;
  String serviceNum;
  String user_name;
  String user_id;
  String user_email;
  int reportNum;
  BusinessData({
    required this.serviceId,
    required this.serviceName,
    required this.serviceType,
    required this.serviceCity,
    required this.serviceImg,
    required this.serviceNum,
    this.reportNum = 0,
    this.user_name = '',
    this.user_id = '',
    this.user_email = '',
  });
}
