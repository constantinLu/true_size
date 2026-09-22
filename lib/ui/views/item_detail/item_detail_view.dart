import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/dates.dart';
import '../../common/app_widgets.dart';
import '../../common/detail_widgets.dart';
import '../../common/group_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'item_detail_viewmodel.dart';

class ItemDetailView extends StackedView<ItemDetailViewModel> {
  const ItemDetailView({super.key, required this.measurementId});

  final String measurementId;

  @override
  Widget builder(BuildContext context, ItemDetailViewModel viewModel, Widget? child) {
    if (viewModel.isBusy && viewModel.measurement == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final m = viewModel.measurement;
    if (m == null) {
      return Scaffold(
        appBar: AppBar(leading: CircleBackButton(onTap: viewModel.back)),
        body: Center(child: Text('Measurement not found',
            style: AppTypography.body.copyWith(color: context.neutrals.textSecondary))),
      );
    }

    final accent = viewModel.group == null ? Theme.of(context).colorScheme.primary : groupColor(viewModel.group!.color);
    final brand = m.brandName;
    final hasBrand = brand.isNotEmpty && brand != 'Unknown';

    return DetailScaffold(
      title: m.name,
      actions: [DetailEditButton(onTap: viewModel.edit)],
      children: [
        DetailHero(
          icon: iconForKey(m.icon),
          accent: accent,
          logoUrl: m.brand?.logo,
          value: m.sizesLabel,
          title: m.name,
          subtitle: hasBrand ? '$brand · ${viewModel.groupName}' : viewModel.groupName,
        ),
        const SizedBox(height: 22),
        DetailGroup(rows: [
          for (final s in m.sizes)
            DetailRow(label: m.sizes.length == 1 ? 'Size' : 'Size', value: s.label),
          if (hasBrand) DetailRow(label: 'Brand', value: brand),
          DetailRow(label: 'Group', value: viewModel.groupName),
          DetailRow(label: 'Added', value: formatDateTime(m.createdAt)),
        ]),
        if (m.notes != null && m.notes!.isNotEmpty) ...[
          const SizedBox(height: 16),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: AppTypography.smallMonetary
                    .copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium)),
                const SizedBox(height: 8),
                Text(m.notes!, style: AppTypography.body.copyWith(color: context.neutrals.textPrimary, height: 1.35)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 28),
        _DeleteButton(onTap: () => viewModel.confirmDelete(context)),
      ],
    );
  }

  @override
  ItemDetailViewModel viewModelBuilder(BuildContext context) =>
      ItemDetailViewModel(measurementId: measurementId);

  @override
  void onViewModelReady(ItemDetailViewModel viewModel) => viewModel.initialize();
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const danger = Color(0xFFB36273);
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: danger, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline_rounded, size: 19, color: danger),
            const SizedBox(width: 8),
            Text('Delete measurement', style: AppTypography.button.copyWith(color: danger)),
          ],
        ),
      ),
    );
  }
}
