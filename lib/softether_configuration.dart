import 'package:fsstp/ssl_versions.dart';

class SoftEtherConfiguration {
  final bool verifyHostName;
  final bool verifySSLCert;
  final bool useTrustedCert;
  final bool showDisconnectOnNotification;
  final String notificationText;
  final String sslVersion;
  SoftEtherConfiguration({
    this.verifyHostName = false,
    this.verifySSLCert = false,
    this.useTrustedCert = false,
    this.sslVersion = SSLVersions.DEFAULT,
    this.showDisconnectOnNotification = false,
    this.notificationText = "Connected",
  });

  /// Returns the [SoftEtherConfiguration] instance from the [Map] instance.
  factory SoftEtherConfiguration.fromMap(Map<String, dynamic> map) {
    return SoftEtherConfiguration(
      verifyHostName: bool.tryParse(map['verifyHostName'].toString()) ?? false,
      verifySSLCert: bool.tryParse(map['verifySSLCert'].toString()) ?? false,
      useTrustedCert: bool.tryParse(map['useTrustedCert'].toString()) ?? false,
      sslVersion: map['sslVersion'] ?? 'DEFAULT',
      showDisconnectOnNotification: bool.tryParse(map['showDisconnectOnNotification'].toString()) ?? false,
      notificationText: map['notificationText'] ?? 'Connected',
    );
  }

  /// Returns the [Map] representation of the [SoftEtherConfiguration] instance.
  Map<String, dynamic> toMap() {
    return {
      'verifyHostName': verifyHostName,
      'verifySSLCert': verifySSLCert,
      'useTrustedCert': useTrustedCert,
      'sslVersion': sslVersion,
      'showDisconnectOnNotification': showDisconnectOnNotification,
      'notificationText': notificationText,
    };
  }
}
