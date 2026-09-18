import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/enums/unit.dart';
import '../../common/app_widgets.dart';
import '../../common/form_widgets.dart';
import '../../theme/app_typography.dart';
import 'add_measurement_viewmodel.dart';

class AddMeasurementView extends StackedView<AddMeasurementViewModel> {
  const AddMeasurementView({super.key, required this.groupId});

  final String groupId;

  @override
  Widget builder(BuildContext context, AddMeasurementViewModel viewModel, Widget? child) {
    final primary = Theme.of(context).colorScheme.primary;
    return AddScaffold(
      title: 'Add measurement',
      buttonLabel: 'Add measurement',
      busy: viewModel.isBusy,
      onSubmit: viewModel.canSubmit ? viewModel.submit : null,
      children: [
        Center(
          child: GestureDetector(
            onTap: () => _pickIcon(context, viewModel),
            child: IconMedallion(icon: iconForKey(viewModel.iconKey), color: primary, size: 72, iconSize: 32),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => _pickIcon(context, viewModel),
            child: Text('Choose icon', style: AppTypography.button.copyWith(color: primary)),
          ),
        ),
        const SizedBox(height: 12),
        LabeledField(
          label: 'Name',
          controller: viewModel.nameController,
          hint: 'e.g. Air Max 90, Slim jeans, Duvet',
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: LabeledField(
                label: 'Size / value',
                controller: viewModel.valueController,
                hint: 'e.g. 42 or 200x220',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SelectorField(
                label: 'Unit',
                value: '${viewModel.unit.displayName} (${viewModel.unit.symbol})',
                onTap: () => _pickUnit(context, viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Brand (optional)',
          controller: viewModel.brandController,
          hint: 'e.g. Nike, Zara - logo added automatically',
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Notes (optional)',
          controller: viewModel.notesController,
          hint: 'Anything worth remembering',
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Future<void> _pickIcon(BuildContext context, AddMeasurementViewModel vm) async {
    final res = await showIconPickerSheet(context, selectedKey: vm.iconKey);
    if (res?.iconKey != null) vm.setIcon(res!.iconKey!);
  }

  Future<void> _pickUnit(BuildContext context, AddMeasurementViewModel vm) async {
    final picked = await showSelectionSheet<Unit>(
      context,
      title: 'Unit',
      options: vm.units,
      selected: vm.unit,
      labelOf: (u) => '${u.displayName} (${u.symbol})',
    );
    if (picked != null) vm.setUnit(picked);
  }

  @override
  AddMeasurementViewModel viewModelBuilder(BuildContext context) =>
      AddMeasurementViewModel(groupId: groupId);
}
