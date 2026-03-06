import 'package:ailiotte/core/services/sync_service.dart';
import 'package:ailiotte/features/notes/model/note_model.dart';
import 'package:ailiotte/features/notes/repository/notes_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class NotesController extends GetxController {
  final NotesRepository repo = NotesRepository();
  final SyncService syncService = SyncService();

  final Box queueBox = Hive.box("syncQueue");

  RxList<Note> notes = <Note>[].obs;

  final Uuid uuid = const Uuid();
  RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  /// Load notes from local cache
  void loadNotes() {
    final localNotes = repo.getLocalNotes();

    notes.assignAll(localNotes);

    debugPrint("NOTES LOADED: ${notes.length}");
  }

  /// Add new note (offline-first)
  Future<void> addNote(String text) async {
    final id = uuid.v4();

    final note = Note(
      id: id,
      text: text,
      liked: false,
      updatedAt: DateTime.now(),
    );

    /// Save locally
    await repo.saveLocal(note);

    /// Add to queue
    queueBox.add({
      "type": "add_note",
      "payload": note.toMap(),
      "retryCount": 0,
    });

    debugPrint("QUEUE SIZE AFTER ADD: ${queueBox.length}");

    /// Refresh UI
    loadNotes();

    /// Try syncing
    syncService.processQueue();
  }

  /// Toggle like
  Future<void> toggleLike(Note note) async {
    final updatedNote = Note(
      id: note.id,
      text: note.text,
      liked: !note.liked,
      updatedAt: DateTime.now(),
    );

    /// Update locally
    await repo.saveLocal(updatedNote);

    /// Add to queue
    queueBox.add({
      "type": "like_note",
      "payload": updatedNote.toMap(),
      "retryCount": 0,
    });

    debugPrint("LIKE ACTION QUEUED");

    loadNotes();

    syncService.processQueue();
  }

  Future<void> deleteNote(String id) async {
    /// remove locally
    await repo.notesBox.delete(id);

    /// add action to queue
    final queueBox = Hive.box('syncQueue');

    queueBox.add({
      "type": "delete_note",
      "payload": {"id": id},
      "retryCount": 0,
    });

    loadNotes();

    Get.snackbar(
      "Deleted",
      "Note removed locally",
      snackPosition: SnackPosition.BOTTOM,
    );

    syncService.processQueue();
  }
}
