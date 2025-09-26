import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';

class NetworkController {
  static PublishSubject<bool?> onInternetConnected = PublishSubject<bool?>();

  static final Connectivity _connectivity = Connectivity();
  static bool isInternetConnected = false;

  /// Start Connectivity Stream
  static initialiseNetworkManager() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  /// Close Connectivity Stream
  static disposeStream() {
    onInternetConnected.close();
  }

  /// VPN activation checking
  static Future<bool> isVpnActive() async {
    bool isVpnActive;

    List<NetworkInterface> interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.any,
    );

    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
    interface.name.contains("tun") ||
        interface.name.contains("ppp") ||
        interface.name.contains("pptp"))
        : isVpnActive = false;

    return isVpnActive;
  }

  /// Check Internet Connectivity
  static Future<bool> isConnected() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    return await _checkStatus(result);
  }

  static Future<bool> _checkStatus(ConnectivityResult result) async {
    bool isInternet = false;
    switch (result) {
      case ConnectivityResult.wifi:
        isInternet = true;
        break;
      case ConnectivityResult.mobile:
        isInternet = true;
        break;
      case ConnectivityResult.none:
        isInternet = false;
        break;
      default:
        isInternet = false;
        break;
    }

    if (isInternet) isInternet = await _updateConnectionStatus();

    if (isInternetConnected != isInternet) {
      isInternetConnected = isInternet;
      onInternetConnected.add(isInternet);
    }

    return isInternet;
  }

  static Future<bool> _updateConnectionStatus() async {
    bool isConnected = false;
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }
}
