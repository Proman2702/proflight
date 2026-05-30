class PilotProfile {
  const PilotProfile({
    required this.profileName,
    required this.fio,
    this.company,
    this.flytimeAll = '00:00:00',
    this.flytimeDay = '00:00:00',
    this.flytimeNight = '00:00:00',
    this.addAll = 0,
    this.addDay = 0,
    this.addNight = 0,
    this.airportCodeFormat = 'IATA',
  });

  final String profileName;
  final String fio;
  final String? company;
  final String flytimeAll;
  final String flytimeDay;
  final String flytimeNight;
  final int addAll;
  final int addDay;
  final int addNight;
  final String airportCodeFormat;

  factory PilotProfile.fromJson(Map<String, dynamic> json) => PilotProfile(
    profileName: json['profileName'] as String,
    fio: json['fio'] as String,
    company: json['company'] as String?,
    flytimeAll: json['flytimeAll'] as String? ?? '00:00:00',
    flytimeDay: json['flytimeDay'] as String? ?? '00:00:00',
    flytimeNight: json['flytimeNight'] as String? ?? '00:00:00',
    addAll: json['addAll'] as int? ?? 0,
    addDay: json['addDay'] as int? ?? 0,
    addNight: json['addNight'] as int? ?? 0,
    airportCodeFormat: json['airportCodeFormat'] as String? ?? 'IATA',
  );

  Map<String, dynamic> toJson() => {
    'profileName': profileName,
    'fio': fio,
    if (company != null) 'company': company,
    'flytimeAll': flytimeAll,
    'flytimeDay': flytimeDay,
    'flytimeNight': flytimeNight,
    'addAll': addAll,
    'addDay': addDay,
    'addNight': addNight,
    'airportCodeFormat': airportCodeFormat,
  };

  Map<String, dynamic> toCreateUpdateJson() => {
    'profileName': profileName,
    'fio': fio,
    if (company != null) 'company': company,
    'addAll': addAll,
    'addDay': addDay,
    'addNight': addNight,
  };
}
