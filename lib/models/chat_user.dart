class ChatUser {
  ChatUser({
    required this.image,
    required this.lastActive,
    required this.id,
    required this.isOnline,
    required this.pushToken,
    required this.email,
    required this.username,
  });
  late final String image;
  late final String lastActive;
  late final String id;
  late final bool isOnline;
  late final String pushToken;
  late final String email;
  late final String username;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json['id'] ?? '';
    isOnline = bool.parse(json['is_online']);
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
    username = json['username'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['last_active'] = lastActive;
    _data['id'] = id;
    _data['is_online'] = isOnline;
    _data['push_token'] = pushToken;
    _data['email'] = email;
    _data['username'] = username;
    return _data;
  }
}
