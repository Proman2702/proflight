import 'package:proflight/core/error/result.dart';
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/repositories/server/network_guard.dart';
import 'package:proflight/repositories/server/spring_api_client.dart';

class SpringAppDatabaseRepository implements AppDatabaseRepository {
  SpringAppDatabaseRepository(this._apiClient);

  final SpringApiClient _apiClient;

  @override
  Future<Result<List<PilotProfile>>> listProfiles() {
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.get<List<dynamic>>('/api/profiles');
      final data = response.data ?? const [];
      return Ok(
        data
            .cast<Map<String, dynamic>>()
            .map(PilotProfile.fromJson)
            .toList(growable: false),
      );
    });
  }

  @override
  Future<Result<PilotProfile>> getProfile(String profileName) {
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/api/profiles/$profileName',
      );
      final data = response.data;
      if (data == null) {
        return Err(
          NetworkFailure(
            NetworkFailureType.unknown,
            message: 'Empty profile response',
          ),
        );
      }
      return Ok(PilotProfile.fromJson(data));
    });
  }

  @override
  Future<Result<PilotProfile>> createProfile(PilotProfile profile) {
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/api/profiles',
        data: profile.toCreateUpdateJson(),
      );
      final data = response.data;
      return Ok(data == null ? profile : PilotProfile.fromJson(data));
    });
  }

  @override
  Future<Result<PilotProfile>> replaceProfile(PilotProfile profile) {
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.put<Map<String, dynamic>>(
        '/api/profiles/${profile.profileName}',
        data: profile.toCreateUpdateJson(),
      );
      final data = response.data;
      return Ok(data == null ? profile : PilotProfile.fromJson(data));
    });
  }

  @override
  Future<Result<Unit>> deleteProfile(String profileName) {
    return RepositoryGuard.spring(() async {
      await _apiClient.dio.delete<void>('/api/profiles/$profileName');
      return const Ok(Unit());
    });
  }

  @override
  Future<Result<List<FlightData>>> listFlightDataByProfile(String profileName) {
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.get<List<dynamic>>(
        '/api/profiles/$profileName/flight-data',
      );
      final data = response.data ?? const [];
      return Ok(
        data
            .cast<Map<String, dynamic>>()
            .map(FlightData.fromJson)
            .toList(growable: false),
      );
    });
  }

  @override
  Future<Result<FlightData>> getFlightData(int id) {
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/api/flight-data/$id',
      );
      final data = response.data;
      if (data == null) {
        return Err(
          NetworkFailure(
            NetworkFailureType.unknown,
            message: 'Empty flight data response',
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
    return RepositoryGuard.spring(() async {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/api/profiles/$profileName/flight-data',
        data: flightData.toJson(),
      );
      final data = response.data;
      if (data == null) {
        return Err(
          NetworkFailure(
            NetworkFailureType.unknown,
            message: 'Empty create flight data response',
          ),
        );
      }
      return Ok(FlightData.fromJson(data));
    });
  }

  @override
  Future<Result<FlightData>> replaceFlightData(FlightData flightData) {
    return RepositoryGuard.spring(() async {
      final id = flightData.id;
      if (id == null) {
        return Err(
          DatabaseFailure(
            DatabaseFailureType.invalidArgument,
            message: 'flightData.id is required for replace',
          ),
        );
      }
      final response = await _apiClient.dio.put<Map<String, dynamic>>(
        '/api/flight-data/$id',
        data: flightData.toJson(),
      );
      final data = response.data;
      return Ok(data == null ? flightData : FlightData.fromJson(data));
    });
  }

  @override
  Future<Result<Unit>> deleteFlightData(int id) {
    return RepositoryGuard.spring(() async {
      await _apiClient.dio.delete<void>('/api/flight-data/$id');
      return const Ok(Unit());
    });
  }
}
