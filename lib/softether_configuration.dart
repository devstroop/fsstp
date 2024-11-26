import 'package:sstp_flutter/ssl_versions.dart';

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
}
