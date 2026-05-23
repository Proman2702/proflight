import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/repositories/server/network_guard.dart';

class FirebaseAppDatabaseRepository implements AppDatabaseRepository {
  FirebaseAppDatabaseRepository(this._firestore, this._authRepository);

  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('profiles');
  CollectionReference<Map<String, dynamic>> get _flightData =>
      _firestore.collection('flightData');

  @override
  Future<Result<List<PilotProfile>>> listProfiles() {
    return RepositoryGuard.firebaseDatabase(() async {
      final uid = _requireUserId();
      final snapshot = await _profiles.where('ownerUid', isEqualTo: uid).get();
      return snapshot.docs
          .map((doc) => PilotProfile.fromJson(doc.data()))
          .toList(growable: false);
    });
  }

  @override
  Future<Result<PilotProfile>> getProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      final doc = await _profiles.doc(profileName).get();
      final data = doc.data();
      if (data == null || data['ownerUid'] != _requireUserId()) {
        throw DatabaseFailure(
          DatabaseFailureType.notFound,
          message: 'Profile not found',
        );
      }
      return PilotProfile.fromJson(data);
    });
  }

  @override
  Future<Result<PilotProfile>> createProfile(PilotProfile profile) {
    return RepositoryGuard.firebaseDatabase(() async {
      await _profiles.doc(profile.profileName).set({
        ...profile.toJson(),
        'ownerUid': _requireUserId(),
      });
      return profile;
    });
  }

  @override
  Future<Result<PilotProfile>> replaceProfile(PilotProfile profile) {
    return RepositoryGuard.firebaseDatabase(() async {
      await _profiles.doc(profile.profileName).set({
        ...profile.toJson(),
        'ownerUid': _requireUserId(),
      });
      return profile;
    });
  }

  @override
  Future<Result<Unit>> deleteProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      await _profiles.doc(profileName).delete();
      return const Unit();
    });
  }

  @override
  Future<Result<List<FlightData>>> listFlightDataByProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      final snapshot = await _flightData
          .where('ownerUid', isEqualTo: _requireUserId())
          .where('profileName', isEqualTo: profileName)
          .get();
      return snapshot.docs
          .map((doc) => FlightData.fromJson(doc.data()))
          .toList(growable: false);
    });
  }

  @override
  Future<Result<FlightData>> getFlightData(int id) {
    return RepositoryGuard.firebaseDatabase(() async {
      final doc = await _flightData.doc(id.toString()).get();
      final data = doc.data();
      if (data == null || data['ownerUid'] != _requireUserId()) {
        throw DatabaseFailure(
          DatabaseFailureType.notFound,
          message: 'Flight data not found',
        );
      }
      return FlightData.fromJson(data);
    });
  }

  @override
  Future<Result<FlightData>> createFlightData({
    required String profileName,
    required FlightData flightData,
  }) {
    return RepositoryGuard.firebaseDatabase(() async {
      final id = flightData.id ?? DateTime.now().microsecondsSinceEpoch;
      final data = {
        ...flightData.toJson(),
        'id': id,
        'profileName': profileName,
        'ownerUid': _requireUserId(),
      };
      await _flightData.doc(id.toString()).set(data);
      return FlightData.fromJson(data);
    });
  }

  @override
  Future<Result<FlightData>> replaceFlightData(FlightData flightData) {
    return RepositoryGuard.firebaseDatabase(() async {
      final id = flightData.id;
      if (id == null) {
        throw ArgumentError('flightData.id is required for replace');
      }
      await _flightData.doc(id.toString()).set({
        ...flightData.toJson(),
        'ownerUid': _requireUserId(),
      }, SetOptions(merge: true));
      return flightData;
    });
  }

  @override
  Future<Result<Unit>> deleteFlightData(int id) {
    return RepositoryGuard.firebaseDatabase(() async {
      await _flightData.doc(id.toString()).delete();
      return const Unit();
    });
  }

  String _requireUserId() {
    final id = _authRepository.currentUser?.id;
    if (id == null) {
      throw DatabaseFailure(
        DatabaseFailureType.unauthenticated,
        message: 'No current user',
      );
    }
    return id;
  }
}
