class SSTPConfiguration {
  bool? enableTLS;
  bool? enablePAP;
  bool? enableCHAP;
  bool? enableMSCHAP2;

  SSTPConfiguration(
      {this.enableTLS = false,
      this.enablePAP = false,
      this.enableCHAP = false,
      this.enableMSCHAP2 = true});

  /// Returns the [SSTPConfiguration] instance from the [Map] instance.
  factory SSTPConfiguration.fromMap(Map<String, dynamic> map) {
    return SSTPConfiguration(
      enableTLS: map['enableTLS'],
      enablePAP: map['enablePAP'],
      enableCHAP: map['enableCHAP'],
      enableMSCHAP2: map['enableMSCHAP2'],
    );
  }

  /// Returns the [Map] representation of the [SSTPConfiguration] instance.
  Map<String, dynamic> toMap() {
    return {
      'enableTLS': enableTLS,
      'enablePAP': enablePAP,
      'enableCHAP': enableCHAP,
      'enableMSCHAP2': enableMSCHAP2,
    };
  }
}
