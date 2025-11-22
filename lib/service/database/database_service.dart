import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proflight/entities/flight.dart';
import 'package:proflight/entities/user.dart';

abstract class DatabaseService<T> {
  Stream<QuerySnapshot<T>> getElements();

  Future<void> upsertElement(T user, String id);

  Future<void> deleteElement(String id);
}

class UserDatabaseService implements DatabaseService<User> {
  final FirebaseFirestore _firestore;
  late final CollectionReference<User> _sessionsRef;
  final collectionPath = 'users';

  UserDatabaseService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance {
    _sessionsRef = _firestore
        .collection(collectionPath)
        .withConverter<User>(
          fromFirestore: (snap, _) {
            final data = snap.data() ?? <String, dynamic>{};
            return User.fromJson({...data, 'id': snap.id});
          },
          toFirestore: (user, _) => user.toJson(),
        );
  }

  @override
  Stream<QuerySnapshot<User>> getElements() {
    return _sessionsRef.snapshots();
  }

  @override
  Future<void> upsertElement(User user, String id) async {
    await _sessionsRef.doc(id).set(user, SetOptions(merge: true));
  }

  @override
  Future<void> deleteElement(String id) async {
    await _sessionsRef.doc(id).delete();
  }
}

class FlightDatabaseService implements DatabaseService<Flight> {
  final String id;
  final FirebaseFirestore _firestore;
  late final CollectionReference<Flight> _sessionsRef;
  final String collectionPath;

  FlightDatabaseService({FirebaseFirestore? firestore, required this.id})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      collectionPath = "users/$id/flights" {
    _sessionsRef = _firestore
        .collection(collectionPath)
        .withConverter<Flight>(
          fromFirestore: (snap, _) {
            final data = snap.data() ?? <String, dynamic>{};
            return Flight.fromJson({...data, 'id': snap.id});
          },
          toFirestore: (user, _) => user.toJson(),
        );
  }

  @override
  Stream<QuerySnapshot<Flight>> getElements() {
    return _sessionsRef.snapshots();
  }

  @override
  Future<void> upsertElement(Flight flight, String id) async {
    await _sessionsRef.doc(id).set(flight, SetOptions(merge: true));
  }

  @override
  Future<void> deleteElement(String id) async {
    await _sessionsRef.doc(id).delete();
  }
}
