import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appliance.dart';

class ApplianceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Appliance> _appliances = [];
  bool _isLoading = false;
  
  List<Appliance> get appliances => _appliances;
  bool get isLoading => _isLoading;
  
  double get dailyUsage {
    return _appliances.fold(0.0, (sum, app) => sum + app.dailyEnergy);
  }
  
  double get monthlyUsage => dailyUsage * 30;

  // Predefined appliances
  static final List<Appliance> predefinedAppliances = [
    Appliance(id: '1', name: 'Ceiling Fan', icon: 'fan', wattage: 75),
    Appliance(id: '2', name: 'LED Bulb', icon: 'lightbulb', wattage: 12),
    Appliance(id: '3', name: 'Refrigerator', icon: 'fridge', wattage: 150),
    Appliance(id: '4', name: 'Air Conditioner', icon: 'ac', wattage: 1500),
    Appliance(id: '5', name: 'TV', icon: 'tv', wattage: 100),
    Appliance(id: '6', name: 'Washing Machine', icon: 'washer', wattage: 500),
    Appliance(id: '7', name: 'Microwave', icon: 'microwave', wattage: 1200),
    Appliance(id: '8', name: 'Computer', icon: 'computer', wattage: 200),
  ];

  Future<void> loadAppliances() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('appliances')
          .get();
      
      _appliances = snapshot.docs
          .map((doc) => Appliance.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error loading appliances: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAppliance(Appliance appliance) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('appliances')
          .add(appliance.toJson());
      
      _appliances.add(appliance.copyWith(id: docRef.id));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding appliance: $e');
    }
  }

  Future<void> updateAppliance(Appliance appliance) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('appliances')
          .doc(appliance.id)
          .update(appliance.toJson());
      
      final index = _appliances.indexWhere((a) => a.id == appliance.id);
      if (index != -1) {
        _appliances[index] = appliance;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating appliance: $e');
    }
  }

  Future<void> removeAppliance(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('appliances')
          .doc(id)
          .delete();
      
      _appliances.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing appliance: $e');
    }
  }

  void clearAppliances() {
    _appliances.clear();
    notifyListeners();
  }
}
