import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/location.dart';

class LocationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Location> _locations = [];
  bool _isLoading = false;
  String? _selectedLocation;
  
  List<Location> get locations => _locations;
  bool get isLoading => _isLoading;
  String? get selectedLocation => _selectedLocation;

  Future<void> loadLocations() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('locations')
          .orderBy('createdAt', descending: true)
          .get();
      
      _locations = snapshot.docs
          .map((doc) => Location.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error loading locations: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLocation(Location location) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('locations')
          .add(location.toJson());
      
      _locations.insert(0, Location(
        id: docRef.id,
        name: location.name,
        icon: location.icon,
        dailyUsage: location.dailyUsage,
        address: location.address,
        userId: user.uid,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding location: $e');
    }
  }

  Future<void> updateLocation(Location location) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('locations')
          .doc(location.id)
          .update(location.toJson());
      
      final index = _locations.indexWhere((l) => l.id == location.id);
      if (index != -1) {
        _locations[index] = location;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  Future<void> removeLocation(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('locations')
          .doc(id)
          .delete();
      
      _locations.removeWhere((l) => l.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing location: $e');
    }
  }

  void setSelectedLocation(String? locationId) {
    _selectedLocation = locationId;
    notifyListeners();
  }
}
