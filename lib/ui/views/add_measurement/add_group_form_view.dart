import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/app_icons.dart';
import '../../common/app_widgets.dart';
import '../../common/form_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'add_group_form_viewmodel.dart';

class AddGroupFormView extends StackedView<AddGroupFormViewModel> {
  const AddGroupFormView({super.key});

  @override
  Widget builder(BuildContext context, AddGroupFormViewModel viewModel, Widget? child) {
    return AddScaffold(
      title: 'New group',
      buttonLabel: 'Create group',
      busy: viewModel.isBusy,
      onSubmit: viewModel.canSubmit ? viewModel.submit : null,
      children: [
        Center(
          child: GestureDetector(
            onTap: () => _pickIcon(context, viewModel),
            child: IconMedallion(icon: iconForKey(viewModel.iconKey), color: viewModel.color, size: 76, iconSize: 34),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => _pickIcon(context, viewModel),
            child: Text('Choose icon', style: AppTypography.button.copyWith(color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        const SizedBox(height: 12),
        LabeledField(
          label: 'Name',
          controller: viewModel.nameController,
          hint: 'e.g. Shoes, Jeans, Bedding',
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 22),
        Text('Colour',
            style: AppTypography.smallMonetary
                .copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium)),
        const SizedBox(height: 12),
        _ColorSwatches(viewModel),
      ],
    );
  }

  Future<void> _pickIcon(BuildContext context, AddGroupFormViewModel vm) async {
    final res = await showIconPickerSheet(context, selectedKey: vm.iconKey);
    if (res?.iconKey != null) vm.setIcon(res!.iconKey!);
  }

  @override
  AddGroupFormViewModel viewModelBuilder(BuildContext context) => AddGroupFormViewModel();
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches(this.vm);
  final AddGroupFormViewModel vm;

  @override
  Widget build(BuildContext context) {
    const columns = 6;
    const spacing = 10.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final c in vm.colorChoices)
              GestureDetector(
                onTap: () => vm.setColor(c),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(14),
                    border: c.toARGB32() == vm.color.toARGB32()
                        ? Border.all(color: context.neutrals.textPrimary, width: 3)
                        : null,
                  ),
                  child: c.toARGB32() == vm.color.toARGB32()
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}
