import 'package:proflight/models/flight_data.dart';

class FlightFormatters {
  const FlightFormatters._();

  static Duration parseDuration(String? value) {
    if (value == null || value.isEmpty) return Duration.zero;
    final parts = value.split(':').map(int.tryParse).toList();
    if (parts.length != 3 || parts.any((part) => part == null)) {
      return Duration.zero;
    }
    return Duration(hours: parts[0]!, minutes: parts[1]!, seconds: parts[2]!);
  }

  static String durationHm(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static String durationHms(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String dateRu(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  static String apiDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime? parseApiDate(String value) => DateTime.tryParse(value);

  static int countLandings(List<FlightData> flights) {
    return flights.where((flight) => flight.placeArrival != null).length;
  }
}
