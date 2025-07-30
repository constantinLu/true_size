import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../common/palette.dart';
import '../../widget/icon_selector_view.dart';
import '../add_group_form_viewmodel.dart';
import '../helper.dart';
import '../icons_helper.dart';

class DisplayIconWidget extends StatelessWidget {
  const DisplayIconWidget({
    super.key,
    required this.context,
    required this.viewModel,
  });

  final BuildContext context;
  final AddGroupFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBackgroundIcons(),
        SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.3, // 30% of screen height
          child: Center(
            child: GestureDetector(
              onTap: showIconSelector,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: whiteCultured, width: 3),
                ),
                child: Icon(
                  allIcons[viewModel.selectedIcon],
                  size: 50,
                  color: Palette.whiteCultured,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showIconSelector() async {
    await Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => IconSelectorView(
          allIcons: allIcons,
          onIconSelected: (iconName) {
            viewModel.selectIcon(iconName);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
