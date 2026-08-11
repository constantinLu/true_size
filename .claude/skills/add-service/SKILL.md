---
name: add-service
description: Scaffold a new Firestore-backed service (and its model) for true_size, register it as a LazySingleton in app.dart, and run codegen. Use when the user wants to add a new service, data model, or Firestore collection, or invokes /add-service.
user-invocable: true
---

# add-service

Add a new Firestore-backed service (and optionally its model) following this project's conventions.

## Steps

1. **Model** (if a new entity) — create `lib/core/models/<entity>.dart` matching the pattern in `lib/core/models/group.dart` / `measurement.dart`:
   - `final` fields + a required-args constructor
   - `Map<String, dynamic> toFirestore()`
   - `factory <Entity>.fromFirestore(DocumentSnapshot doc)` with `data['x'] ?? default` guards
   - `copyWith(...)`, `==`/`hashCode` on `id`
   - **Guard timestamp casts** (`(data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()`) — avoids the crash noted in [[project-dual-group-data-layers]].

2. **Service** — create `lib/services/<entity>_service.dart` matching `group_service.dart`:
   - `final FirebaseFirestore _firestore = FirebaseFirestore.instance;`
   - `static const String _collection = '<entities>';`
   - a `CollectionReference get _ref => _firestore.collection(_collection);`
   - CRUD methods (`add`, `get`, `getAll`, `update`, `delete`), each wrapped in try/catch throwing a dedicated `<Entity>ServiceException`.
   - Depend on other services via `locator<...>()` when relations are needed.

3. **Register DI** in `lib/app/app.dart` under `@StackedApp(dependencies: [...])`:
   `LazySingleton(classType: <Entity>Service),`

4. **Run codegen** (see `codegen` skill): `dart run build_runner build --delete-conflicting-outputs` to update `app.locator.dart`.

5. **Verify** with `flutter analyze`.

## Notes
- Follow [[feedback-discuss-before-changing]] — agree on the collection name, fields, and whether it streams vs. one-shot fetch before writing files.
- Heads up: this project already has **two** group data layers (`FirestoreService` and `GroupService`) that disagree — don't add a third overlapping path; extend the right existing one. See [[project-dual-group-data-layers]].
