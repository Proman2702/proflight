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
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      final snapshot = await _profiles.where('ownerUid', isEqualTo: uid).get();
      return Ok(
        snapshot.docs
            .map((doc) => PilotProfile.fromJson(doc.data()))
            .toList(growable: false),
      );
    });
  }

  @override
  Future<Result<PilotProfile>> getProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      final doc = await _profiles.doc(profileName).get();
      final data = doc.data();
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      if (data == null || data['ownerUid'] != uid) {
        return Err(
          DatabaseFailure(
            DatabaseFailureType.notFound,
            message: 'Profile not found',
          ),
        );
      }
      return Ok(PilotProfile.fromJson(data));
    });
  }

  @override
  Future<Result<PilotProfile>> createProfile(PilotProfile profile) {
    return RepositoryGuard.firebaseDatabase(() async {
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      await _profiles.doc(profile.profileName).set({
        ...profile.toJson(),
        'ownerUid': uid,
      });
      return Ok(profile);
    });
  }

  @override
  Future<Result<PilotProfile>> replaceProfile(PilotProfile profile) {
    return RepositoryGuard.firebaseDatabase(() async {
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      await _profiles.doc(profile.profileName).set({
        ...profile.toJson(),
        'ownerUid': uid,
      });
      return Ok(profile);
    });
  }

  @override
  Future<Result<Unit>> deleteProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      await _profiles.doc(profileName).delete();
      return const Ok(Unit());
    });
  }

  @override
  Future<Result<List<FlightData>>> listFlightDataByProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      final snapshot = await _flightData
          .where('ownerUid', isEqualTo: uid)
          .where('profileName', isEqualTo: profileName)
          .get();
      return Ok(
        snapshot.docs
            .map((doc) => FlightData.fromJson(doc.data()))
            .toList(growable: false),
      );
    });
  }

  @override
  Future<Result<FlightData>> getFlightData(int id) {
    return RepositoryGuard.firebaseDatabase(() async {
      final doc = await _flightData.doc(id.toString()).get();
      final data = doc.data();
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      if (data == null || data['ownerUid'] != uid) {
        return Err(
          DatabaseFailure(
            DatabaseFailureType.notFound,
            message: 'Flight data not found',
          ),
        );
      }
      return Ok(FlightData.fromJson(data));
    });
  }

  @override
  Future<Result<FlightData>> createFlightData({
    required String profileName,
    required FlightData flightData,
  }) {
    return RepositoryGuard.firebaseDatabase(() async {
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      final id = flightData.id ?? DateTime.now().microsecondsSinceEpoch;
      final data = {
        ...flightData.toJson(),
        'id': id,
        'profileName': profileName,
        'ownerUid': uid,
      };
      await _flightData.doc(id.toString()).set(data);
      return Ok(FlightData.fromJson(data));
    });
  }

  @override
  Future<Result<FlightData>> replaceFlightData(FlightData flightData) {
    return RepositoryGuard.firebaseDatabase(() async {
      final id = flightData.id;
      if (id == null) {
        return Err(
          DatabaseFailure(
            DatabaseFailureType.invalidArgument,
            message: 'flightData.id is required for replace',
          ),
        );
      }
      final uidResult = _requireUserId();
      if (uidResult is Err<String>) return Err(uidResult.error);
      final uid = (uidResult as Ok<String>).value;
      await _flightData.doc(id.toString()).set({
        ...flightData.toJson(),
        'ownerUid': uid,
      }, SetOptions(merge: true));
      return Ok(flightData);
    });
  }

  @override
  Future<Result<Unit>> deleteFlightData(int id) {
    return RepositoryGuard.firebaseDatabase(() async {
      await _flightData.doc(id.toString()).delete();
      return const Ok(Unit());
    });
  }

  Result<String> _requireUserId() {
    final id = _authRepository.currentUser?.id;
    if (id == null) {
      return Err(
        DatabaseFailure(
          DatabaseFailureType.unauthenticated,
          message: 'No current user',
        ),
      );
    }
    return Ok(id);
  }
}
