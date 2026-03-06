# AI Prompt Log

### Prompt 1

How to implement an offline sync queue in Flutter using Hive.

Response Summary:
Suggested storing actions in a persistent queue and processing them when internet connectivity is restored.

Decision:
Accepted with modifications.

Reason:
Retry logic and idempotency were added to meet assignment requirements.

---

### Prompt 2

How to implement retry logic for network operations in Flutter.

Response Summary:
Suggested retry counters with delayed retry attempts.

Decision:
Modified.

Reason:
Assignment required only one retry attempt.

---

### Prompt 3

Best way to structure Flutter apps for offline-first architecture.

Response Summary:
Suggested repository pattern with separation of local and remote data sources.

Decision:
Accepted.

Reason:
Improves maintainability and scalability.
