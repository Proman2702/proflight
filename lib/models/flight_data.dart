class FlightData {
  const FlightData({
    this.id,
    required this.flightDate,
    required this.number,
    this.planeNumber,
    this.flight,
    this.placeDeparture,
    this.placeArrival,
    this.placeArrival2,
    this.timeOn,
    this.timeOff,
    this.timeDeparture,
    this.timeArrival,
    this.timePvp,
    this.timePpp,
    this.etd,
    this.eta,
    this.timeAll,
    this.timeAir,
    this.timeDay,
    this.timeNight,
    this.timePvpPppAll,
    this.etdEtaAll,
  });

  final int? id;
  final String flightDate;
  final int number;
  final String? planeNumber;
  final String? flight;
  final String? placeDeparture;
  final String? placeArrival;
  final String? placeArrival2;
  final String? timeOn;
  final String? timeOff;
  final String? timeDeparture;
  final String? timeArrival;
  final String? timePvp;
  final String? timePpp;
  final String? etd;
  final String? eta;
  final String? timeAll;
  final String? timeAir;
  final String? timeDay;
  final String? timeNight;
  final String? timePvpPppAll;
  final String? etdEtaAll;

  factory FlightData.fromJson(Map<String, dynamic> json) => FlightData(
    id: json['id'] as int?,
    flightDate: json['flightDate'] as String,
    number: json['number'] as int,
    planeNumber: json['planeNumber'] as String?,
    flight: json['flight'] as String?,
    placeDeparture: json['placeDeparture'] as String?,
    placeArrival: json['placeArrival'] as String?,
    placeArrival2: json['placeArrival2'] as String?,
    timeOn: json['timeOn'] as String?,
    timeOff: json['timeOff'] as String?,
    timeDeparture: json['timeDeparture'] as String?,
    timeArrival: json['timeArrival'] as String?,
    timePvp: json['timePvp'] as String?,
    timePpp: json['timePpp'] as String?,
    etd: json['etd'] as String?,
    eta: json['eta'] as String?,
    timeAll: json['timeAll'] as String?,
    timeAir: json['timeAir'] as String?,
    timeDay: json['timeDay'] as String?,
    timeNight: json['timeNight'] as String?,
    timePvpPppAll: json['timePvpPppAll'] as String?,
    etdEtaAll: json['etdEtaAll'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'flightDate': flightDate,
    'number': number,
    'planeNumber': planeNumber,
    'flight': flight,
    'placeDeparture': placeDeparture,
    'placeArrival': placeArrival,
    'placeArrival2': placeArrival2,
    'timeOn': timeOn,
    'timeOff': timeOff,
    'timeDeparture': timeDeparture,
    'timeArrival': timeArrival,
    'timePvp': timePvp,
    'timePpp': timePpp,
    'etd': etd,
    'eta': eta,
    'timeAll': timeAll,
    'timeAir': timeAir,
    'timeDay': timeDay,
    'timeNight': timeNight,
    'timePvpPppAll': timePvpPppAll,
    'etdEtaAll': etdEtaAll,
  };
}
