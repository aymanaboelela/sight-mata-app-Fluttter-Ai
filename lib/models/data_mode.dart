class DataModel {
  final String? id;
  final String userid;
  final String username;
  final String email;
  final double? distance;
  final double? lat;
  final double? lon;

  DataModel({
    this.id,
    required this.userid,
    required this.username,
    required this.email,
    this.distance,
    this.lat,
    this.lon,
  });

  // تحويل البيانات من JSON
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] ?? '', // التأكد من أن id موجود في البيانات
      userid: json['userid'],
      username: json['username'],
      email: json['email'],
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lon: json['lon'] != null ? (json['lon'] as num).toDouble() : null,
    );
  }

  // تحويل الكائن إلى JSON لإرساله إلى Supabase
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'username': username,
      'email': email,
      'distance': distance,
      'lat': lat,
      'lon': lon,
    };
  }
}
