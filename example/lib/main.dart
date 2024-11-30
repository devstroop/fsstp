import 'package:flutter/material.dart';
import 'package:fsstp/vpn_server.dart';
import 'package:fsstp/softether_configuration.dart';
import 'package:fsstp/ssl_versions.dart';
import 'package:fsstp/sstp_configuration.dart';
import 'package:fsstp/fsstp.dart';
import 'package:fsstp/traffic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final fsstpPlugin = FSSTP();
  var connectionStatus = "disconnected";
  var certDir = "none";
  var downSpeed = 0;
  var upSpeed = 0;
  Duration connectionTimer = const Duration();

  TextEditingController hostNameController = TextEditingController();
  TextEditingController sslPortController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    connectionStatus = await fsstpPlugin.checkLastConnectionStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter SSTP example app'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("connectionStatus : $connectionStatus"),
                  Text("download Speed : $downSpeed KBps"),
                  Text("upload Speed : $downSpeed KBps"),
                  Text("certificate dir : $certDir"),
                  Text("connection time : $connectionTimer"),
                ],
              ),
              TextField(
                controller: hostNameController,
                decoration: const InputDecoration(hintText: "host name"),
              ),
              TextField(
                controller: sslPortController,
                decoration: const InputDecoration(hintText: "ssl port"),
              ),
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(hintText: "user name"),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(hintText: "password"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        VPNServer server = VPNServer(
                          host: hostNameController.text,
                          port: 443,
                          username: userNameController.text,
                          password: passController.text,
                          softEtherConfiguration: SoftEtherConfiguration(
                            verifyHostName: false,
                            useTrustedCert: false,
                            verifySSLCert: false,
                            sslVersion: SSLVersions.TLSv1_1,
                            showDisconnectOnNotification: true,
                            notificationText: "Notification Text Holder",
                          ),
                          sstpConfiguration: SSTPConfiguration(
                            enableMSCHAP2: true,
                            enableCHAP: false,
                            enablePAP: false,
                            enableTLS: true,
                          ),
                        );

                        try {
                          await fsstpPlugin.takePermission();
                          await fsstpPlugin
                              .takePermission()
                              .then((value) async {
                            await fsstpPlugin
                                .saveServerData(server: server)
                                .then((value) async {
                              await fsstpPlugin.connectVpn();
                            });
                          });
                        } catch (e) {
                          debugPrint(e.toString());
                        }

                        fsstpPlugin.onResult(
                            onConnectedResult:
                                (ConnectionTraffic traffic, Duration duration) {
                              setState(() {
                                connectionTimer = duration;
                                connectionStatus = "connected";
                                downSpeed = traffic.downloadTraffic ?? 0;
                                upSpeed = traffic.uploadTraffic ?? 0;
                              });
                            },
                            onConnectingResult: () {
                              debugPrint("onConnectingResult");
                              setState(() {
                                connectionStatus = "connecting";
                              });
                            },
                            onDisconnectedResult: () {
                              debugPrint("onDisconnectedResult");
                              setState(() {
                                connectionStatus = "disconnected";
                                downSpeed = 0;
                                upSpeed = 0;
                              });
                            },
                            onError: () {});
                      },
                      child: const Text("Connect")),
                  ElevatedButton(
                      onPressed: () async {
                        await fsstpPlugin.disconnect();
                      },
                      child: const Text("Disconnect"))
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    certDir = await fsstpPlugin.addCertificate();
                    setState(() {});
                  },
                  child: const Text("Certificate"))
            ],
          ),
        )),
      ),
    );
  }
}
