import 'package:fsstp/softether_configuration.dart';
import 'package:fsstp/sstp_configuration.dart';

class SSTPServer {
  final String host;
  final int port;
  final String username;
  final String password;
  final SoftEtherConfiguration softEtherConfiguration;
  final SSTPConfiguration sstpConfiguration;

  SSTPServer(
      {required this.host,
      this.port = 443,
      required this.username,
      required this.password,
      required this.softEtherConfiguration,
      required this.sstpConfiguration});
}
