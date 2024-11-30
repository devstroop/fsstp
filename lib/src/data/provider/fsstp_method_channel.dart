import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fsstp/app_info.dart';
import 'package:fsstp/proxy.dart';
import 'package:fsstp/vpn_server.dart';

class MethodChannelFSSTP {
  final methodChannelCaller = const MethodChannel('fsstp');

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannelCaller.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future connectVpn() async {
    try {
      await methodChannelCaller.invokeMethod("connect");
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future disconnect() async {
    try {
      await methodChannelCaller.invokeMethod("disconnect");
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future saveCnnectionStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("connected", value);
  }

  Future vpnPermission() async {
    try {
      await methodChannelCaller.invokeMethod("takePermission");
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<InstalledAppInfo>> getInstalledApps() async {
    List<InstalledAppInfo> appInfoList = [];
    List<dynamic> apps = await methodChannelCaller.invokeMethod("getApps");
    appInfoList = apps.map((app) => InstalledAppInfo.create(app)).toList();

    appInfoList.sort((a, b) => a.name!.compareTo(b.name!));
    return appInfoList;
  }

  Future<List<String>> getAllowedApps() async {
    List<Object?> receiver = await methodChannelCaller
        .invokeMethod("getAllowedApps"); //returns list of package names
    List<String> caller = [];

    for (var element in receiver) {
      caller.add(element.toString());
    }
    return caller;
  }

  Future addToAllowedApps(List<String> pkgName) async {
    var caller = await methodChannelCaller
        .invokeMethod("addAllowedApps", {"packageName": pkgName});
    return caller;
  }

  Future enableDNS({required String customDNS}) async {
    await methodChannelCaller
        .invokeMethod("enableDns", {"customDns": customDNS});
  }

  Future disableDNS() async {
    await methodChannelCaller.invokeMethod("disableDns");
  }

  Future enableProxy({required SSTPProxy proxy}) async {
    await methodChannelCaller.invokeMethod("enableProxy", {
      "proxyIp": proxy.ip,
      "proxyPort": proxy.port,
      "proxyUserName": proxy.userName ?? "",
      "proxyPassword": proxy.password ?? "",
    });
  }

  Future disableProxy() async {
    await methodChannelCaller.invokeMethod("disableProxy");
  }

  Future saveServerData({required VPNServer server}) async {
    try {
      debugPrint(
          "Saving server data: host=${server.host}, port=${server.port}, username=${server.username}");
      var res = await methodChannelCaller.invokeMethod("saveServer", {
        "hostName": server.host,
        "sslPort": server.port,
        "userName": server.username,
        "password": server.password,
        "verifyHostName": server.softEtherConfiguration?.verifyHostName,
        "verifySSLCert": server.softEtherConfiguration?.verifySSLCert,
        "useTrustedCert": server.softEtherConfiguration?.useTrustedCert,
        "sslVersion": server.softEtherConfiguration?.sslVersion,
        "showDisconnectOnNotification":
            server.softEtherConfiguration?.showDisconnectOnNotification,
        "notificationText": server.softEtherConfiguration?.notificationText,
        "enableCHAP": server.sstpConfiguration?.enableCHAP,
        "enablePAP": server.sstpConfiguration?.enablePAP,
        "enableTLS": server.sstpConfiguration?.enableTLS,
        "enableMSCHAP2": server.sstpConfiguration?.enableMSCHAP2,
      });
      debugPrint(res.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> checkLastConnectionStatus() async {
    String status =
        await methodChannelCaller.invokeMethod("checkLastConnectionStatus");
    return status;
  }

  Future<String> addCertificate() async {
    String caller =
        await methodChannelCaller.invokeMethod("addTrustedCertificate");
    return caller;
  }

  static final MethodChannelFSSTP _instance = MethodChannelFSSTP.internal();
  factory MethodChannelFSSTP() => _instance;
  MethodChannelFSSTP.internal();
}
