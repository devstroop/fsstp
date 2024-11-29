# FSSTP

FSSTP is a Flutter plugin for SSTP/SoftEther VPN connections. It provides a convenient way to manage SSTP/SoftEther VPN connections, monitor connection status, and configure various settings.

## Features

- Connect to SSTP/SoftEther VPN server
- Monitor connection status and duration
- Retrieve download and upload speed
- Enable and disable DNS
- Enable and disable proxy
- Save server data for quick connection
- Check the last connection status
- Get installed apps and manage allowed apps

## Getting Started

To use this plugin, add `fsstp` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  fsstp: ^version
```

Then, run `flutter pub get` to install the dependency.

## iOS Setup

### <b>1. Add Capabillity</b>
Add <b>Network Extensions</b> capabillity on Runner's Target and enable <b>Packet Tunnel</b>

<img src ='https://github.com/devstroop/fsstp/blob/main/example/sc/1.png?raw=true'>

### <b>2. Add New Target</b>

Click + button on bottom left, Choose <b>NETWORK EXTENSION</b>. And set <b>Language</b> and <b>Provider  Type</b> to <b>Objective-C</b> and <b>Packet Tunnel</b> as image below.

<img src ='https://github.com/devstroop/fsstp/blob/main/example/sc/2.png?raw=true'>

### <b>3. Add Capabillity to sstp_extension</b>

Repeat the step 1 for new target you created on previous step (sstp_extension)

### <b>4. Add Framework Search Path</b>

Select sstp_extension and add the following lines to your <b>Build Setting</b> > <b>Framework Search Path</b>:

```
$(SRCROOT)/.symlinks/plugins/fsstp/ios/ext
```
```
$(SRCROOT)/.symlinks/plugins/fsstp/ios/openconnect
```

### <b>5. Copy Paste</b>

Open Target (Network Extensions) > PacketTunnelProvider.m and copy paste this script <a href="https://raw.githubusercontent.com/devstroop/fsstp/refs/heads/main/example/ios/sstp_extension/PacketTunnelProvider.m">PacketTunnelProvider.m</a>


## Example

```dart
import 'package:fsstp/fsstp.dart';

void main() async {
  FSSTP fsstp = FSSTP();
  var cert_dir = "";

  // Take VPN permission
  await fsstp.takePermission();
  
  // Create an SSTP server object
VPNServer server = VPNServer(
   host: hostNameController.text,
   port: int.parse(sslPortController.text),
   username: userNameController.text,
   password: passController.text,
   softEtherConfiguration: SoftEtherConfiguration(
       verifyHostName: false,
       useTrustedCert: false,
       verifySSLCert: false,
       sslVersion: SSLVersions.TLSv1_1,
       showDisconnectOnNotification: true,
       notificationText: "Connected",
   ),
   sstpConfiguration: SSTPConfiguration(
       enableMSCHAP2: true,
       enableCHAP: false,
       enablePAP: false,
       enableTLS: false,
   ),
);
  
  // Save created SSTP server
  await fsstp.saveServerData(server: server);

  // Opens files and then returns selected directory path (Android only)
  certDir = await fsstpPlugin.addCertificate();

  // Connect to SSTP VPN
  await fsstp.connectVpn();

  // Monitor connection status
  fsstpPlugin.onResult(
      onConnectedResult: (ConnectionTraffic traffic, Duration duration) {
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

  // Disconnect from  VPN
  await fsstp.disconnect();

  // Get installed apps (Android only)
  List<InstalledAppInfo> installedApps = await fsstp.getInstalledApps();
  print('Installed Apps: $installedApps');

  // Get allowed apps (Android only)
  List<String> allowedApps = await fsstp.getAllowedApps();
  print('Allowed Apps: $allowedApps');

  // Add apps to allowed apps (Android only)
  await fsstp.addToAllowedApps(packages: ['com.example.app']);

  // Enable DNS (Android only)
  await fsstp.enableDns(DNS: '8.8.8.8');

  // Disable DNS (Android only)
  await fsstp.disableDNS();

  // Enable proxy (Android only)
  await fsstp.enableProxy(proxy: SSTPProxy(host: 'proxy.example.com', port: 8080));

  // Disable proxy (Android only)
  await fsstp.disableProxy();

  // Check last connection status
  UtilKeys status = await fsstp.checkLastConnectionStatus();
  print('Last Connection Status: $status');
}
```

Please note that the plugin methods may throw exceptions (`PlatformException`). Handle them appropriately in your application.

## Contributions and Issues

Feel free to contribute to this project by submitting pull requests or reporting issues on the [GitHub repository](https://github.com/devstroop/fsstp).

This addition emphasizes that the purpose of the plugin is to provide a secure means for web surfing using SSTP/SoftEther VPN connections. Adjustments can be made based on your specific requirements.

