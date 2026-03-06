import 'package:ailiotte/features/notes/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class NotesRepository {
  final Box notesBox = Hive.box('notes');

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Get cached notes
  List<Note> getLocalNotes() {
    final data = notesBox.values.toList();

    debugPrint("LOCAL NOTES COUNT: ${data.length}");

    return data.map((e) => Note.fromMap(Map.from(e))).toList();
  }

  /// Save note locally
  Future<void> saveLocal(Note note) async {
    await notesBox.put(note.id, note.toMap());

    debugPrint("LOCAL SAVE SUCCESS: ${note.id}");
  }

  /// Update local note
  Future<void> updateLocal(Note note) async {
    await notesBox.put(note.id, note.toMap());

    debugPrint("LOCAL UPDATE SUCCESS: ${note.id}");
  }

  /// Sync note to Firebase
  Future<void> syncNote(Note note) async {
    try {
      await firestore.collection("notes").doc(note.id).set(note.toMap());

      debugPrint("FIREBASE SYNC SUCCESS: ${note.id}");
    } catch (e) {
      debugPrint("FIREBASE SYNC FAILED: $e");

      rethrow;
    }
  }

  /// Fetch latest notes from Firebase
  Future<List<Note>> fetchRemoteNotes() async {
    final snapshot = await firestore.collection("notes").get();

    final notes = snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();

    debugPrint("REMOTE NOTES COUNT: ${notes.length}");

    return notes;
  }
}
