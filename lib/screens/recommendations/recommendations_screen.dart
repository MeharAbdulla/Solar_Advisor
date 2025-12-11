import 'package:flutter/material.dart';
import '../../models/solar_system.dart';
import '../../utils/colors.dart';

class RecommendationsScreen extends StatelessWidget {
  final double dailyUsage;

  const RecommendationsScreen({super.key, required this.dailyUsage});

  List<SolarSystem> _getRecommendations() {
    return [
      SolarSystem(
        id: '1',
        name: 'Eco Starter',
        description: 'Best for small power cuts',
        tier: 'basic',
        panelCount: 2,
        panelWattage: 350,
        batteryCount: 1,
        batteryType: '150Ah',
        inverterCapacity: 1,
        estimatedCost: 1200,
        borderColor: '10B981',
        badgeColor: '10B981',
        iconColor: '10B981',
      ),
      SolarSystem(
        id: '2',
        name: 'Home Standard',
        description: 'Covers 80% of needs',
        tier: 'standard',
        panelCount: 6,
        panelWattage: 450,
        batteryCount: 2,
        batteryType: '200Ah',
        inverterCapacity: 3,
        estimatedCost: 3500,
        borderColor: 'FF7518',
        badgeColor: 'FF7518',
        iconColor: 'FF7518',
      ),
      SolarSystem(
        id: '3',
        name: 'Total Off-Grid',
        description: 'Total energy independence',
        tier: 'premium',
        panelCount: 12,
        panelWattage: 500,
        batteryCount: 4,
        batteryType: 'Li-ion',
        inverterCapacity: 8,
        estimatedCost: 8200,
        borderColor: '3B82F6',
        badgeColor: '3B82F6',
        iconColor: '3B82F6',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final systems = _getRecommendations();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recommendations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: systems.length,
        itemBuilder: (context, index) {
          final system = systems[index];
          final isPopular = system.tier == 'standard';

          return Padding(
            padding: EdgeInsets.only(bottom: 16, top: isPopular ? 8 : 0),
            child: Transform.scale(
              scale: isPopular ? 1.05 : 1.0,
              child: _SystemCard(system: system, isPopular: isPopular),
            ),
          );
        },
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  final SolarSystem system;
  final bool isPopular;

  const _SystemCard({required this.system, required this.isPopular});

  Color _getColor(String hex) {
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _getColor(system.borderColor);
    final iconColor = _getColor(system.iconColor);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? borderColor : Colors.transparent,
          width: isPopular ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isPopular ? 0.1 : 0.03),
            blurRadius: isPopular ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text(
                'MOST POPULAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          if (!isPopular)
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: borderColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    system.tier.toUpperCase(),
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(isPopular ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  system.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  system.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '\$${system.estimatedCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'est.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isPopular ? borderColor.withOpacity(0.05) : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SpecItem(
                  icon: Icons.solar_power,
                  value: system.panelCount.toString(),
                  label: 'Panels (${system.panelWattage}W)',
                  color: iconColor,
                ),
                _SpecItem(
                  icon: Icons.battery_charging_full,
                  value: system.batteryCount.toString(),
                  label: 'Batteries (${system.batteryType})',
                  color: iconColor,
                ),
                _SpecItem(
                  icon: Icons.bolt,
                  value: '${system.inverterCapacity}kW',
                  label: 'Inverter',
                  color: iconColor,
                ),
              ],
            ),
          ),

          if (isPopular)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Select Standard',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SpecItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
