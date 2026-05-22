import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/pin.dart';
import '../data/repositories/pin_repository.dart';

class PinProvider extends ChangeNotifier {
  final PinRepository _repository = PinRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Pin> _pins = [];
  bool _isLoading = false;
  String? _error;
  String? _anonymousUserId;

  // Getters
  List<Pin> get pins => _pins;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get anonymousUserId => _anonymousUserId;

  // Inicializa auth anónimo y escucha pins
  Future<void> initialize() async {
    try {
      // Login anónimo — si ya tiene sesión la reutiliza
      final user = await _auth.signInAnonymously();
      _anonymousUserId = user.user?.uid;

      // Escucha cambios en tiempo real
      _repository.getPins().listen((pins) {
        _pins = pins;
        notifyListeners(); // 👈 como OnPropertyChanged
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createPin({
    required double lat,
    required double lng,
    required String comment,
    required String category,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final pin = Pin(
        id: '',
        lat: lat,
        lng: lng,
        comment: comment,
        category: category,
        createdAt: DateTime.now(),
        anonymousUserId: _anonymousUserId ?? '',
      );

      await _repository.createPin(pin);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reportPin(String pinId) async {
    try {
      await _repository.reportPin(pinId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
