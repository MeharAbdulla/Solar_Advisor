class Appliance {
  final String id;
  final String name;
  final String icon;
  final int wattage;
  int quantity;
  double hoursPerDay;

  Appliance({
    required this.id,
    required this.name,
    required this.icon,
    required this.wattage,
    this.quantity = 1,
    this.hoursPerDay = 1.0,
  });

  double get dailyEnergy => (wattage * quantity * hoursPerDay) / 1000; // kWh

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'wattage': wattage,
    'quantity': quantity,
    'hoursPerDay': hoursPerDay,
  };

  factory Appliance.fromJson(Map<String, dynamic> json) => Appliance(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String,
    wattage: json['wattage'] as int,
    quantity: json['quantity'] as int? ?? 1,
    hoursPerDay: (json['hoursPerDay'] as num?)?.toDouble() ?? 1.0,
  );

  Appliance copyWith({
    String? id,
    String? name,
    String? icon,
    int? wattage,
    int? quantity,
    double? hoursPerDay,
  }) {
    return Appliance(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      wattage: wattage ?? this.wattage,
      quantity: quantity ?? this.quantity,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
    );
  }
}
