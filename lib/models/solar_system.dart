class SolarSystem {
  final String id;
  final String name;
  final String description;
  final String tier; // basic, standard, premium
  final int panelCount;
  final int panelWattage;
  final int batteryCount;
  final String batteryType;
  final int inverterCapacity;
  final double estimatedCost;
  final String borderColor;
  final String badgeColor;
  final String iconColor;

  SolarSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.panelCount,
    required this.panelWattage,
    required this.batteryCount,
    required this.batteryType,
    required this.inverterCapacity,
    required this.estimatedCost,
    required this.borderColor,
    required this.badgeColor,
    required this.iconColor,
  });

  int get totalCapacity => panelCount * panelWattage;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'tier': tier,
    'panelCount': panelCount,
    'panelWattage': panelWattage,
    'batteryCount': batteryCount,
    'batteryType': batteryType,
    'inverterCapacity': inverterCapacity,
    'estimatedCost': estimatedCost,
    'borderColor': borderColor,
    'badgeColor': badgeColor,
    'iconColor': iconColor,
  };

  factory SolarSystem.fromJson(Map<String, dynamic> json) => SolarSystem(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    tier: json['tier'] as String,
    panelCount: json['panelCount'] as int,
    panelWattage: json['panelWattage'] as int,
    batteryCount: json['batteryCount'] as int,
    batteryType: json['batteryType'] as String,
    inverterCapacity: json['inverterCapacity'] as int,
    estimatedCost: (json['estimatedCost'] as num).toDouble(),
    borderColor: json['borderColor'] as String,
    badgeColor: json['badgeColor'] as String,
    iconColor: json['iconColor'] as String,
  );
}
