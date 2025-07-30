import 'package:stacked_services/stacked_services.dart';

import '../core/enums/bottom_sheet_type.dart';
import '../core/sheet/icon_selector_sheet.dart';
import 'app.locator.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.iconSelector: (context, sheetRequest, completer) =>
        IconSelectorSheet(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
