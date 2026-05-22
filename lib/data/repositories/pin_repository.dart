import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pin.dart';

class PinRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'pins';

  // Escucha cambios en tiempo real — como SignalR en .NET
  Stream<List<Pin>> getPins() {
    return _db
        .collection(_collection)
        .where('isHidden', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pin.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createPin(Pin pin) async {
    try {
      await _db.collection(_collection).add(pin.toFirestore());
    } catch (e) {
      throw Exception('Error creating pin: $e');
    }
  }

  Future<void> reportPin(String pinId) async {
    final doc = await _db.collection(_collection).doc(pinId).get();
    final currentReports = doc.data()?['reportCount'] ?? 0;

    await _db.collection(_collection).doc(pinId).update({
      'reportCount': FieldValue.increment(1),
      // Si tiene 10 o más reportes → se oculta automáticamente
      'isHidden': currentReports >= 10,
    });
  }

  Future<void> deletePin(String pinId) async {
    try {
      await _db.collection(_collection).doc(pinId).delete();
    } catch (e) {
      throw Exception('Error deleting pin: $e');
    }
  }
}
