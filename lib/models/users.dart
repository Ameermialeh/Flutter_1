class Users {
  String name;
  String email;
  int phone;
  String city;

  Users({
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
  });
}

List<Users> UsersList = [
  Users(
    name: 'Ameer mialeh',
    email: "ameerinad@hotmail.com",
    phone: 0597433042,
    city: "Nablus",
  ),
  Users(
    name: 'Zayd loay',
    email: "zaydloay@hotmail.com",
    phone: 0569101036,
    city: "Nablus",
  ),
];
