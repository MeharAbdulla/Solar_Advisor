import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appliance_provider.dart';
import '../../models/appliance.dart';
import '../../utils/colors.dart';
import '../recommendations/recommendations_screen.dart';

class CalculateLoadScreen extends StatefulWidget {
  const CalculateLoadScreen({super.key});

  @override
  State<CalculateLoadScreen> createState() => _CalculateLoadScreenState();
}

class _CalculateLoadScreenState extends State<CalculateLoadScreen> {
  bool _isAppliancesView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplianceProvider>().loadAppliances();
    });
  }

  void _showAddApplianceDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AddApplianceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Calculate Load'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle Switch
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ToggleButton(
                      label: 'Add Appliances',
                      isSelected: _isAppliancesView,
                      onTap: () => setState(() => _isAppliancesView = true),
                    ),
                  ),
                  Expanded(
                    child: _ToggleButton(
                      label: 'Upload Bill',
                      isSelected: !_isAppliancesView,
                      onTap: () => setState(() => _isAppliancesView = false),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isAppliancesView
                ? _AppliancesView(onAddPressed: _showAddApplianceDialog)
                : const _UploadBillView(),
          ),

          // Bottom Calculation Bar
          const _CalculationFooter(),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.textDark : AppColors.textGray,
          ),
        ),
      ),
    );
  }
}

class _AppliancesView extends StatelessWidget {
  final VoidCallback onAddPressed;

  const _AppliancesView({required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplianceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'YOUR APPLIANCES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textGray,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.appliances.map((appliance) => _ApplianceCard(appliance: appliance)),
            const SizedBox(height: 12),
            _AddApplianceButton(onPressed: onAddPressed),
          ],
        );
      },
    );
  }
}

class _ApplianceCard extends StatelessWidget {
  final Appliance appliance;

  const _ApplianceCard({required this.appliance});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'fan':
        return Icons.wind_power;
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'fridge':
        return Icons.kitchen;
      case 'ac':
        return Icons.ac_unit;
      case 'tv':
        return Icons.tv;
      case 'washer':
        return Icons.local_laundry_service;
      case 'microwave':
        return Icons.microwave;
      case 'computer':
        return Icons.computer;
      default:
        return Icons.electrical_services;
    }
  }

  Color _getIconColor(String iconName) {
    switch (iconName) {
      case 'fan':
      case 'lightbulb':
        return AppColors.brandGreen;
      case 'fridge':
      case 'ac':
        return AppColors.brandBlue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ApplianceProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconColor(appliance.icon).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(_getIcon(appliance.icon), color: _getIconColor(appliance.icon)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appliance.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appliance.wattage}W per unit',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.grey.shade300),
                onPressed: () => provider.removeAppliance(appliance.id),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: TextEditingController(text: appliance.quantity.toString()),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          final qty = int.tryParse(value) ?? 1;
                          provider.updateAppliance(appliance.copyWith(quantity: qty));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hours/Day',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: TextEditingController(
                          text: appliance.hoursPerDay.toStringAsFixed(1),
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          final hours = double.tryParse(value) ?? 1.0;
                          provider.updateAppliance(appliance.copyWith(hoursPerDay: hours));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddApplianceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddApplianceButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.textGray),
            const SizedBox(width: 8),
            Text(
              'Add Appliance',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadBillView extends StatelessWidget {
  const _UploadBillView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.brandBlue, width: 2, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload, size: 48, color: AppColors.brandBlue),
                const SizedBox(height: 12),
                Text(
                  'Upload Bill Image',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlue,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Supports JPG, PNG, PDF',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '- OR -',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average Monthly Cost (\$)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'e.g. 150',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculationFooter extends StatelessWidget {
  const _CalculationFooter();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplianceProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 25,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Usage',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                      Text(
                        '${provider.dailyUsage.toStringAsFixed(1)} kWh',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Monthly Usage',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                      Text(
                        '${provider.monthlyUsage.toStringAsFixed(0)} kWh',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandGreen.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecommendationsScreen(
                          dailyUsage: provider.dailyUsage,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Calculate System',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddApplianceSheet extends StatelessWidget {
  const _AddApplianceSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Appliance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...ApplianceProvider.predefinedAppliances.map((appliance) {
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.electrical_services),
                    ),
                    title: Text(appliance.name),
                    subtitle: Text('${appliance.wattage}W'),
                    onTap: () {
                      context.read<ApplianceProvider>().addAppliance(appliance);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
