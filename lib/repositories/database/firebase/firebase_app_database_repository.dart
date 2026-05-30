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

  @override
  Future<Result<List<PilotProfile>>> listProfiles() {
    return RepositoryGuard.firebaseDatabase(() async {
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      final snapshot = await userDoc.collection('profiles').get();
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
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      final doc = await userDoc.collection('profiles').doc(profileName).get();
      final data = doc.data();
      if (data == null) {
        return Err(DatabaseFailure(DatabaseFailureType.notFound));
      }
      return Ok(PilotProfile.fromJson(data));
    });
  }

  @override
  Future<Result<PilotProfile>> createProfile(PilotProfile profile) {
    return RepositoryGuard.firebaseDatabase(() async {
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      await userDoc
          .collection('profiles')
          .doc(profile.profileName)
          .set(profile.toJson());
      return Ok(profile);
    });
  }

  @override
  Future<Result<PilotProfile>> replaceProfile(PilotProfile profile) {
    return RepositoryGuard.firebaseDatabase(() async {
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      await userDoc
          .collection('profiles')
          .doc(profile.profileName)
          .set(profile.toJson());
      return Ok(profile);
    });
  }

  @override
  Future<Result<Unit>> deleteProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      await userDoc.collection('profiles').doc(profileName).delete();
      return const Ok(Unit());
    });
  }

  @override
  Future<Result<List<FlightData>>> listFlightDataByProfile(String profileName) {
    return RepositoryGuard.firebaseDatabase(() async {
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      final snapshot = await userDoc
          .collection('flight-data')
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
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      final doc = await userDoc
          .collection('flight-data')
          .doc(id.toString())
          .get();
      final data = doc.data();
      if (data == null) {
        return Err(DatabaseFailure(DatabaseFailureType.notFound));
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
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      final id = flightData.id ?? DateTime.now().microsecondsSinceEpoch;
      final data = {
        ...flightData.toJson(),
        'id': id,
        'profileName': profileName,
      };
      await userDoc.collection('flight-data').doc(id.toString()).set(data);
      return Ok(FlightData.fromJson(data));
    });
  }

  @override
  Future<Result<FlightData>> replaceFlightData(FlightData flightData) {
    return RepositoryGuard.firebaseDatabase(() async {
      final id = flightData.id;
      if (id == null) {
        return Err(DatabaseFailure(DatabaseFailureType.invalidArgument));
      }
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      final current = await userDoc
          .collection('flight-data')
          .doc(id.toString())
          .get();
      final currentProfileName = current.data()?['profileName'];
      await userDoc.collection('flight-data').doc(id.toString()).set({
        ...flightData.toJson(),
        if (currentProfileName != null) 'profileName': currentProfileName,
      });
      return Ok(flightData);
    });
  }

  @override
  Future<Result<Unit>> deleteFlightData(int id) {
    return RepositoryGuard.firebaseDatabase(() async {
      final userDocResult = _requireUserDoc();
      if (userDocResult is Err<DocumentReference<Map<String, dynamic>>>) {
        return Err(userDocResult.error);
      }
      final userDoc =
          (userDocResult as Ok<DocumentReference<Map<String, dynamic>>>).value;
      await userDoc.collection('flight-data').doc(id.toString()).delete();
      return const Ok(Unit());
    });
  }

  Result<DocumentReference<Map<String, dynamic>>> _requireUserDoc() {
    final id = _authRepository.currentUser?.id;
    if (id == null) {
      return Err(DatabaseFailure(DatabaseFailureType.unauthenticated));
    }
    return Ok(_firestore.collection('users').doc(id));
  }
}
