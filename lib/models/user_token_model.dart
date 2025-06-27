class UserTokenModel {
  final String id;
  final String fcmToken;
  final bool userType;

  UserTokenModel({
    required this.id,
    required this.fcmToken,
    required this.userType,
  });

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      id: json['id'] as String,
      fcmToken: json['fcm_token'] as String,
      userType: json['user_type'] as bool,
    );
  }
}
