import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sync_service.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  final SyncService syncService = SyncService();

  void startListening() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        debugPrint("INTERNET RESTORED");

        /// Snackbar to notify user
        Get.snackbar(
          "Internet Restored",
          "Syncing pending notes...",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          duration: const Duration(seconds: 2),
        );

        /// Start syncing queue
        syncService.processQueue();
      }
    });
  }
}
