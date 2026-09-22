import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/models/measurement.dart';
import '../../../core/models/unit_option.dart';
import '../../common/app_widgets.dart';
import '../../common/form_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'add_measurement_viewmodel.dart';

class AddMeasurementView extends StackedView<AddMeasurementViewModel> {
  const AddMeasurementView({super.key, required this.groupId, this.existing});

  final String groupId;
  final Measurement? existing;

  @override
  Widget builder(BuildContext context, AddMeasurementViewModel viewModel, Widget? child) {
    final primary = Theme.of(context).colorScheme.primary;
    return AddScaffold(
      title: viewModel.isEditing ? 'Edit measurement' : 'Add measurement',
      buttonLabel: viewModel.isEditing ? 'Save changes' : 'Add measurement',
      busy: viewModel.isBusy,
      onSubmit: viewModel.canSubmit ? viewModel.submit : null,
      children: [
        Center(
          child: PressableScale(
            onTap: () => _pickIcon(context, viewModel),
            child: IconMedallion(icon: iconForKey(viewModel.iconKey), color: primary, size: 72, iconSize: 32),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: PressableScale.wrap(
            child: TextButton(
              onPressed: () => _pickIcon(context, viewModel),
              child: Text('Choose icon', style: AppTypography.button.copyWith(color: primary)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        LabeledField(
          label: 'Name',
          controller: viewModel.nameController,
          hint: 'e.g. Air Max 90, Zara jeans, Duvet',
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 18),
        Text('Sizes',
            style: AppTypography.smallMonetary
                .copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium)),
        const SizedBox(height: 10),
        for (int i = 0; i < viewModel.sizeEntries.length; i++) ...[
          if (i != 0) const SizedBox(height: 10),
          _SizeRow(vm: viewModel, index: i),
        ],
        const SizedBox(height: 12),
        _AddSizeButton(onTap: viewModel.addSize),
        const SizedBox(height: 18),
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

  @override
  AddMeasurementViewModel viewModelBuilder(BuildContext context) =>
      AddMeasurementViewModel(groupId: groupId, existing: existing);
}

class _SizeRow extends StatelessWidget {
  const _SizeRow({required this.vm, required this.index});
  final AddMeasurementViewModel vm;
  final int index;

  @override
  Widget build(BuildContext context) {
    final entry = vm.sizeEntries[index];
    final canRemove = vm.sizeEntries.length > 1;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _PlainField(
            controller: entry.controller,
            hint: 'e.g. 42 or 200x220',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: PressableScale(
            onTap: () => _pickUnit(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
              decoration: BoxDecoration(
                color: context.neutrals.surfaceHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.unit.symbol.isEmpty ? entry.unit.label : entry.unit.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                          color: context.neutrals.textPrimary, fontWeight: AppTypography.medium),
                    ),
                  ),
                  Icon(Icons.expand_more_rounded, size: 20, color: context.neutrals.textSecondary),
                ],
              ),
            ),
          ),
        ),
        if (canRemove) ...[
          const SizedBox(width: 6),
          PressableScale(
            onTap: () => vm.removeSize(index),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.close_rounded, size: 20, color: context.neutrals.textFaint),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickUnit(BuildContext context) async {
    final picked = await showSelectionSheet<UnitOption>(
      context,
      title: 'Unit',
      subtitle: 'Pick a unit, or create your own',
      options: vm.units,
      selected: vm.sizeEntries[index].unit,
      labelOf: (u) => u.symbol.isEmpty ? u.label : '${u.label} · ${u.symbol}',
      canDelete: vm.canDeleteUnit,
      onDelete: (u) async {
        await vm.deleteUnit(u);
        return null;
      },
      onCreateNew: () async {
        final res = await showCreateUnitSheet(context);
        if (res == null) return null;
        return vm.createUnit(res.name, res.symbol);
      },
    );
    if (picked != null) vm.setUnit(index, picked);
  }
}

/// A bare rounded text field (no label) used inside the size rows.
class _PlainField extends StatelessWidget {
  const _PlainField({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.neutrals.surfaceHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        style: AppTypography.body
            .copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTypography.body.copyWith(color: context.neutrals.textFaint),
        ),
      ),
    );
  }
}

class _AddSizeButton extends StatelessWidget {
  const _AddSizeButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: primary.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 19, color: primary),
            const SizedBox(width: 8),
            Text('Add another size', style: AppTypography.button.copyWith(color: primary)),
          ],
        ),
      ),
    );
  }
}
