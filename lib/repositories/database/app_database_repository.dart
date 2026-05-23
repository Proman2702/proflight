import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';

abstract interface class AppDatabaseRepository {
  Future<Result<List<PilotProfile>>> listProfiles();

  Future<Result<PilotProfile>> getProfile(String profileName);

  Future<Result<PilotProfile>> createProfile(PilotProfile profile);

  Future<Result<PilotProfile>> replaceProfile(PilotProfile profile);

  Future<Result<Unit>> deleteProfile(String profileName);

  Future<Result<List<FlightData>>> listFlightDataByProfile(String profileName);

  Future<Result<FlightData>> getFlightData(int id);

  Future<Result<FlightData>> createFlightData({
    required String profileName,
    required FlightData flightData,
  });

  Future<Result<FlightData>> replaceFlightData(FlightData flightData);

  Future<Result<Unit>> deleteFlightData(int id);
}
