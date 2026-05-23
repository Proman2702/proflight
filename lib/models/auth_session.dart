class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresInSeconds = 900,
    this.email,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresInSeconds;
  final String? email;

  factory AuthSession.fromJson(Map<String, dynamic> json, {String? email}) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresInSeconds: json['expiresInSeconds'] as int? ?? 900,
      email: email ?? json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'tokenType': tokenType,
    'expiresInSeconds': expiresInSeconds,
    if (email != null) 'email': email,
  };
}
