---
name: scaffold-view
description: Scaffold a new Stacked view + viewmodel for true_size, register its route in app.dart, and run codegen. Use when the user wants to add a new screen/page/view, create a Stacked view, or invokes /scaffold-view.
user-invocable: true
---

# scaffold-view

Create a new Stacked (MVVM) view in this project following its existing conventions.

Given a view name (e.g. `settings`, `profile`), the user may also pass a route path (default `/<name>`). Confirm the name and path if ambiguous.

## Steps

1. **Create the folder** `lib/ui/views/<name>/` with two files.

2. **`<name>_view.dart`** — a `StackedView<<Name>ViewModel>` (match the style of `lib/ui/views/home/home_view.dart`). Skeleton:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:stacked/stacked.dart';

   import '<name>_viewmodel.dart';

   class <Name>View extends StackedView<<Name>ViewModel> {
     const <Name>View({super.key});

     @override
     Widget builder(BuildContext context, <Name>ViewModel viewModel, Widget? child) {
       return Scaffold(
         body: SafeArea(child: Center(child: Text('<Name>'))),
       );
     }

     @override
     <Name>ViewModel viewModelBuilder(BuildContext context) => <Name>ViewModel();
   }
   ```

3. **`<name>_viewmodel.dart`** — `extends BaseViewModel` (or `StreamViewModel<T>` / `FormViewModel` if the screen streams data or is a form; ask if unclear). Pull services via `locator<...>()` as in existing viewmodels.

4. **Register the route** in `lib/app/app.dart` inside `@StackedApp(routes: [...])`:
   `MaterialRoute(page: <Name>View, path: '/<name>'),`

5. **Run codegen** — see the `codegen` skill, or run:
   `dart run build_runner build --delete-conflicting-outputs`
   This regenerates `app.router.dart` / `app.locator.dart` so `navigateTo<Name>View()` exists.

6. **Verify** with `flutter analyze` and report any errors.

## Notes
- Follow [[feedback-discuss-before-changing]] — confirm the view name, base viewmodel type, and route before creating files.
- Match surrounding import style (relative imports within a view folder, `package:true_size/...` across folders) and the project's Lexend/dark-theme conventions.
