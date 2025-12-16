import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen(_handleStatus);
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isOnline = ValueNotifier(false);
  late final StreamSubscription<ConnectivityResult> _subscription;

  Stream<ConnectivityResult> get changes => _connectivity.onConnectivityChanged;

  Future<bool> hasConnection() async {
    final status = await _connectivity.checkConnectivity();
    return status != ConnectivityResult.none;
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> _init() async {
    final status = await _connectivity.checkConnectivity();
    _handleStatus(status);
  }

  void _handleStatus(ConnectivityResult status) {
    isOnline.value = status != ConnectivityResult.none;
  }
}
