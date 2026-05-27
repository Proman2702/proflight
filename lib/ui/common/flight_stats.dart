import 'package:proflight/models/flight_data.dart';
import 'package:proflight/ui/common/flight_formatters.dart';

class FlightStats {
  const FlightStats({
    required this.total,
    required this.day,
    required this.night,
    required this.flights,
    required this.landings,
  });

  final Duration total;
  final Duration day;
  final Duration night;
  final int flights;
  final int landings;

  String get totalLabel => FlightFormatters.durationHm(total);
  String get dayLabel => FlightFormatters.durationHm(day);
  String get nightLabel => FlightFormatters.durationHm(night);

  factory FlightStats.fromFlights(List<FlightData> flights) {
    Duration sum(String? Function(FlightData flight) pick) {
      return flights.fold(Duration.zero, (acc, flight) {
        return acc + FlightFormatters.parseDuration(pick(flight));
      });
    }

    return FlightStats(
      total: sum((flight) => flight.timeAll),
      day: sum((flight) => flight.timeDay),
      night: sum((flight) => flight.timeNight),
      flights: flights.length,
      landings: FlightFormatters.countLandings(flights),
    );
  }
}
