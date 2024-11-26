import 'package:fsstp/softether_configuration.dart';
import 'package:fsstp/sstp_configuration.dart';

class VPNServer {
  final String host;
  final int port;
  final String username;
  final String password;
  final SoftEtherConfiguration? softEtherConfiguration;
  final SSTPConfiguration? sstpConfiguration;

  VPNServer(
      {required this.host,
      this.port = 443,
      required this.username,
      required this.password,
      this.softEtherConfiguration,
      this.sstpConfiguration});

  /// Returns the [VPNServer] instance from the [Map] representation.
  static VPNServer fromMap(Map<String, dynamic> map) {
    return VPNServer(
      host: map['host'],
      port: map['port'],
      username: map['username'],
      password: map['password'],
      softEtherConfiguration: SoftEtherConfiguration.fromMap(map),
      sstpConfiguration: SSTPConfiguration.fromMap(map),
    );
  }

  /// Returns the [Map] representation of the [VPNServer] instance.
  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      ...softEtherConfiguration?.toMap() ?? {},
      ...sstpConfiguration?.toMap() ?? {},
    };
  }
}
