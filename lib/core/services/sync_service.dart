import 'package:ailiotte/features/notes/controller/notes_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class SyncService {
  final Box queueBox = Hive.box('syncQueue');

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> processQueue() async {
    Get.find<NotesController>().isSyncing.value = true;

    debugPrint("SYNC STARTED");
    debugPrint("QUEUE SIZE: ${queueBox.length}");

    if (queueBox.isEmpty) {
      debugPrint("QUEUE EMPTY");
      Get.find<NotesController>().isSyncing.value = false;
      return;
    }

    for (var key in queueBox.keys.toList()) {
      final item = Map<String, dynamic>.from(queueBox.get(key));

      try {
        debugPrint("PROCESSING ITEM: $item");

        final payload = Map<String, dynamic>.from(item["payload"]);

        /// 🔹 Handle delete operation
        if (item["type"] == "delete_note") {
          await firestore.collection("notes").doc(payload["id"]).delete();

          debugPrint("FIREBASE DELETE SUCCESS: ${payload["id"]}");
        }

        /// 🔹 Handles both add and like operations
        if (item["type"] == "add_note" || item["type"] == "like_note") {
          await firestore.collection("notes").doc(payload["id"]).set(payload);

          debugPrint("FIREBASE SYNC SUCCESS: ${payload["id"]}");
        }

        /// Remove from queue after success
        await queueBox.delete(key);

        debugPrint("QUEUE ITEM REMOVED");

        /// Show snackbar when queue finishes syncing
        if (queueBox.isEmpty) {
          Get.snackbar(
            "Sync Complete",
            "Notes synced with server",
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(12),
            borderRadius: 10,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        debugPrint("SYNC FAILED: $e");

        /// Retry logic
        int retryCount = item["retryCount"] ?? 0;

        if (retryCount < 1) {
          retryCount++;

          item["retryCount"] = retryCount;

          await queueBox.put(key, item);

          debugPrint("RETRYING... attempt: $retryCount");

          await Future.delayed(const Duration(seconds: 2));

          await processQueue();
        } else {
          debugPrint("MAX RETRY REACHED - KEEPING IN QUEUE");
        }
      }
    }

    debugPrint("SYNC COMPLETE");

    Get.find<NotesController>().isSyncing.value = false;
  }
}
