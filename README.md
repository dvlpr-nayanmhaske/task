# Offline-First Notes App (Flutter)

## Overview

This project demonstrates an **offline-first mobile architecture** using Flutter.
Users can view cached notes instantly and perform actions such as **adding or liking notes even when offline**.
Offline actions are stored in a **persistent sync queue** and automatically synced to **Firebase Firestore** when internet connectivity is restored.

The goal of this implementation is to demonstrate:

* Offline-first design
* Reliable sync with retry logic
* Idempotent operations
* Persistent action queue
* Observability through logs and UI feedback

---

# Architecture

The application follows a **feature-based MVC architecture** with clear separation of concerns.

UI
↓
Controller (GetX)
↓
Repository
↓
Local Database (Hive)
↓
Sync Queue
↓
Firebase Firestore

### Technologies Used

| Technology         | Purpose                       |
| ------------------ | ----------------------------- |
| Flutter            | Mobile framework              |
| GetX               | State management & navigation |
| Hive               | Local persistence             |
| Firebase Firestore | Backend storage               |
| Connectivity Plus  | Network status detection      |

---

# Key Features

### 1. Local-First Reads

Notes are loaded from **Hive local database** immediately when the app starts.
The UI does not depend on network availability.

### 2. Offline Writes

Users can:

* Add notes
* Like notes

Even when offline.

Actions are stored in a **persistent sync queue**.

### 3. Sync Queue

All offline actions are stored locally in Hive:

Example queue item:

{
"type": "add_note",
"payload": { note data },
"retryCount": 0
}

When internet becomes available, the queue is processed and synced to Firestore.

### 4. Retry Mechanism

If syncing fails due to network issues:

1 retry attempt is triggered with a short delay.

If retry fails, the action remains in the queue.

### 5. Idempotency

Each note uses a **UUID as Firestore document ID**.

This ensures retries do not create duplicate records.

### 6. Conflict Strategy

The project uses a **Last Write Wins** strategy.

Each note contains an `updatedAt` timestamp.
The most recent update overwrites the previous version.

### 7. Observability

Logs are added to monitor system behavior:

Example logs:

SYNC STARTED
QUEUE SIZE: 2
PROCESSING ITEM
FIREBASE SYNC SUCCESS
SYNC COMPLETE

The UI also displays sync feedback via **snackbars and sync indicator icons**.

---

# Sync Flow

Offline Flow

User Action
↓
Saved to Hive
↓
Action added to Queue

Online Flow

Internet Restored
↓
Connectivity Listener triggers Sync
↓
Queue processed
↓
Firebase updated
↓
Queue cleared

---

# Verification Scenarios

### Scenario 1 — Offline Add Note

Steps:

1. Disable internet connection
2. Add a note

Expected result:

* Note appears immediately in UI
* Queue size increases
* No Firebase write occurs

---

### Scenario 2 — Offline Like Note

Steps:

1. Disable internet connection
2. Like a note

Expected result:

* Like action stored in queue
* UI updates locally

---

### Scenario 3 — Sync After Connectivity Returns

Steps:

1. Re-enable internet
2. Sync queue processes automatically

Expected result:

* Notes are written to Firebase
* Queue becomes empty
* Sync completion snackbar appears

---

# Limitations

* Background sync worker not implemented
* Retry attempts limited to one
* Queue deduplication not implemented
* No pagination for notes

---

# Future Improvements

Possible enhancements:

* Background sync worker
* Queue deduplication
* Advanced conflict resolution
* Better error handling UI
* Pagination and filtering

---

# AI Prompt Log

AI tools were used to assist with:

* Offline queue design
* Retry logic implementation
* Flutter architecture guidance

Final implementation decisions were validated manually through testing and debugging.

Full prompt history is available in **AI_PROMPT_LOG.md**

---

# How to Run

1. Clone repository
2. Run:

flutter pub get

3. Configure Firebase
4. Run the application:

flutter run

---

# Conclusion

This project demonstrates a **reliable offline-first architecture** using Flutter with a persistent sync queue, retry logic, and idempotent backend updates.
It ensures smooth user experience even when network connectivity is unstable.


















# ailiotte

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
