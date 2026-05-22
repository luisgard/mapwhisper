import 'package:cloud_firestore/cloud_firestore.dart';

class Pin {
  final String id;
  final double lat;
  final double lng;
  final String comment;
  final String category;
  final DateTime createdAt;
  final String anonymousUserId;
  final int reportCount;
  final bool isHidden;

  Pin({
    required this.id,
    required this.lat,
    required this.lng,
    required this.comment,
    required this.category,
    required this.createdAt,
    required this.anonymousUserId,
    this.reportCount = 0,
    this.isHidden = false,
  });

  factory Pin.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pin(
      id: doc.id,
      lat: data['lat'] ?? 0.0,
      lng: data['lng'] ?? 0.0,
      comment: data['comment'] ?? '',
      category: data['category'] ?? 'general',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      anonymousUserId: data['anonymousUserId'] ?? '',
      reportCount: data['reportCount'] ?? 0,
      isHidden: data['isHidden'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lat': lat,
      'lng': lng,
      'comment': comment,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'anonymousUserId': anonymousUserId,
      'reportCount': reportCount,
      'isHidden': isHidden,
    };
  }
}
