---
name: codegen
description: Run build_runner codegen then flutter analyze for true_size, and summarize the results. Use after changing routes/DI in app.dart, models, or forms, or when the user invokes /codegen.
user-invocable: true
---

# codegen

Regenerate Stacked's generated files and check the project compiles cleanly.

## Steps

1. **Run build_runner** (regenerates `app.router.dart`, `app.locator.dart`, `app.bottomsheet.dart`, `*.form.dart`):

   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```

   `--delete-conflicting-outputs` is important — Stacked regenerates files that otherwise conflict. If it still fails, `dart run build_runner clean` then re-run.

2. **Analyze:**

   ```sh
   flutter analyze
   ```

3. **Summarize** for the user: whether codegen succeeded, which generated files changed, and any analyzer errors/warnings (grouped, with file:line). Don't dump raw output — surface what matters and propose fixes for real errors.

## When to run
- After editing `@StackedApp` routes or dependencies in `lib/app/app.dart` (used by `scaffold-view`, `add-service`).
- After changing a `FormViewModel`'s field annotations (regenerates `*.form.dart`).
- After model changes, to catch breakage before running the app.
