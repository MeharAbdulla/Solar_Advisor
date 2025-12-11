class Location {
  final String id;
  final String name;
  final String icon;
  final double dailyUsage;
  final String? address;
  final String? userId;
  final DateTime createdAt;

  Location({
    required this.id,
    required this.name,
    required this.icon,
    required this.dailyUsage,
    this.address,
    this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get progress => (dailyUsage / 50.0).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'dailyUsage': dailyUsage,
    'address': address,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String,
    dailyUsage: (json['dailyUsage'] as num).toDouble(),
    address: json['address'] as String?,
    userId: json['userId'] as String?,
    createdAt: json['createdAt'] != null 
      ? DateTime.parse(json['createdAt'] as String)
      : DateTime.now(),
  );
}
