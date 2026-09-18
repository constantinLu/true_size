import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app.locator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/dates.dart';
import '../../services/logo_service.dart';
import '../theme/app_typography.dart';
import '../theme/app_neutrals.dart';
import 'app_widgets.dart';

/// Scaffold shared by the four add-entry flows: a plain app bar with a close
/// action, a scrolling body, and a docked primary submit button.
class AddScaffold extends StatelessWidget {
  const AddScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.buttonLabel,
    required this.onSubmit,
    this.busy = false,
  });

  final String title;
  final List<Widget> children;
  final String buttonLabel;
  final VoidCallback? onSubmit;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(title),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: children,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(label: buttonLabel, onTap: onSubmit, busy: busy),
        ),
      ),
    );
  }
}

/// The big centered amount input shown at the top of each add flow.
class AmountField extends StatelessWidget {
  const AmountField({super.key, required this.controller, this.currency = 'RON'});
  final TextEditingController controller;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          textAlign: TextAlign.center,
          style: AppTypography.amountInput.copyWith(color: context.neutrals.textPrimary),
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: '0',
            hintStyle: AppTypography.amountInput.copyWith(color: context.neutrals.textFaint),
          ),
        ),
        const SizedBox(height: 4),
        Text(currency, style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium)),
      ],
    );
  }
}

/// A labelled text field inside a soft surface.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.neutrals.surfaceHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.neutrals.surfaceHigh),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            style: AppTypography.body.copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: context.neutrals.textFaint, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

/// A tappable row (label + current value + chevron) that opens a picker sheet.
class SelectorField extends StatelessWidget {
  const SelectorField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  final String label;
  final String value;
  final IconData? icon;

  /// Optional tint for the leading [icon]. Defaults to the primary text colour.
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: context.neutrals.surfaceHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.neutrals.surfaceHigh),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: iconColor ?? context.neutrals.textPrimary),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body
                        .copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: context.neutrals.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.smallMonetary.copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium));
  }
}

/// A labelled group of single-select squary chips.
class ChipGroup<T> extends StatelessWidget {
  const ChipGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.labelOf,
    this.iconOf,
  });

  final String label;
  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelect;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: [
            for (final o in options)
              SquareChip(
                label: labelOf(o),
                icon: iconOf?.call(o),
                active: o == selected,
                onTap: () => onSelect(o),
              ),
          ],
        ),
      ],
    );
  }
}

/// The squary outlined chip used everywhere. White label (never grey);
/// selection is shown with the primary border + a faint primary fill.
class SquareChip extends StatelessWidget {
  const SquareChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  /// Optional tint for the leading [icon]. Defaults to the primary text colour.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: active ? primary.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? primary : context.neutrals.stroke, width: active ? 1.5 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: iconColor ?? context.neutrals.textPrimary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTypography.subtitle.copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium),
            ),
          ],
        ),
      ),
    );
  }
}

/// A labelled, tappable field that opens a date picker. Pass [onClear] to make
/// the value optional - a clear button then appears once a date is chosen. Set
/// [monthDayOnly] for pay/receive dates: the calendar then hides the year, only
/// day + month are picked (within the current year), and the value shows as a
/// year-less `DD-MMM`.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onPick,
    this.hint = 'Select date',
    this.onClear,
    this.monthDayOnly = false,
  });

  final String label;
  final String value; // ISO yyyy-MM-dd or empty
  final ValueChanged<DateTime> onPick;
  final String hint;
  final VoidCallback? onClear;
  final bool monthDayOnly;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final parsed = value.isEmpty ? now : (DateTime.tryParse(value) ?? now);
            // In month/day mode the calendar lives inside the current year, so a
            // stored date from another year is remapped onto it.
            final initial = monthDayOnly ? DateTime(now.year, parsed.month, parsed.day) : parsed;
            final picked = await showDatePickerSheet(
              context,
              initial: initial,
              firstDate: monthDayOnly ? DateTime(now.year, 1, 1) : DateTime(now.year - 1),
              lastDate: monthDayOnly ? DateTime(now.year, 12, 31) : DateTime(now.year + 10),
              hideYear: monthDayOnly,
            );
            if (picked != null) onPick(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: context.neutrals.surfaceHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.neutrals.surfaceHigh),
            ),
            child: Row(
              children: [
                Icon(Icons.event_rounded, size: 18, color: context.neutrals.textSecondary),
                const SizedBox(width: 10),
                Text(
                  hasValue ? (monthDayOnly ? formatDayMonth(value) : value) : hint,
                  style: AppTypography.body.copyWith(
                    color: hasValue ? context.neutrals.textPrimary : context.neutrals.textFaint,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                const Spacer(),
                if (onClear != null && hasValue)
                  GestureDetector(
                    onTap: onClear,
                    behavior: HitTestBehavior.opaque,
                    child: Icon(Icons.close_rounded, size: 18, color: context.neutrals.textFaint),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-width primary action button (disabled when [onTap] is null).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onTap, this.busy = false});
  final String label;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final enabled = onTap != null && !busy;
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: enabled ? onTap : null,
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          disabledBackgroundColor: primary.withValues(alpha: 0.4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: AppTypography.button,
        ),
        child: busy
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label),
      ),
    );
  }
}

/// A gap used between form sections.
const formGap = SizedBox(height: 22);

// ----- Bottom sheets -----

/// Confirmation sheet with a title, message and two buttons. Returns true when
/// the user confirms, null/false otherwise. Set [destructive] to tint the
/// confirm button red (e.g. for deletes).
Future<bool?> showConfirmSheet(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(message, style: AppTypography.body.copyWith(color: ctx.neutrals.textSecondary, height: 1.4)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ctx.neutrals.textPrimary,
                        side: BorderSide(color: ctx.neutrals.stroke),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        textStyle: AppTypography.button,
                      ),
                      child: Text(cancelLabel),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: destructive ? AppColors.negative : Theme.of(ctx).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        textStyle: AppTypography.button,
                      ),
                      child: Text(confirmLabel),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows a picker sheet of squary chips and returns the chosen option.
/// A trailing "Create your own" chip runs [onCreateNew], and if that returns a
/// value the sheet closes selecting it.
///
/// Long-press a chip to enter delete mode: options for which [canDelete]
/// returns true show a ✕ badge. Tapping it runs [onDelete], which returns an
/// error message to show (e.g. "in use") or null once the option is removed.
Future<T?> showSelectionSheet<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required List<T> options,
  required T? selected,
  required String Function(T) labelOf,
  IconData Function(T)? iconOf,
  Color? Function(T)? colorOf,
  Future<T?> Function()? onCreateNew,
  bool Function(T)? canDelete,
  Future<String?> Function(T)? onDelete,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => _SelectionSheet<T>(
      title: title,
      subtitle: subtitle,
      options: options,
      selected: selected,
      labelOf: labelOf,
      iconOf: iconOf,
      colorOf: colorOf,
      onCreateNew: onCreateNew,
      canDelete: canDelete,
      onDelete: onDelete,
    ),
  );
}

class _SelectionSheet<T> extends StatefulWidget {
  const _SelectionSheet({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.iconOf,
    required this.colorOf,
    required this.onCreateNew,
    required this.canDelete,
    required this.onDelete,
  });

  final String title;
  final String? subtitle;
  final List<T> options;
  final T? selected;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final Color? Function(T)? colorOf;
  final Future<T?> Function()? onCreateNew;
  final bool Function(T)? canDelete;
  final Future<String?> Function(T)? onDelete;

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  late final List<T> _options = List.of(widget.options);
  bool _deleteMode = false;
  String? _error;

  bool _canDelete(T o) => widget.onDelete != null && (widget.canDelete?.call(o) ?? false);

  bool get _anyDeletable => _options.any(_canDelete);

  Future<void> _handleDelete(T o) async {
    final message = await widget.onDelete!(o);
    if (!mounted) return;
    setState(() {
      if (message != null) {
        _error = message; // blocked (e.g. still in use) - keep it in the list.
      } else {
        _error = null;
        _options.remove(o);
        if (!_anyDeletable) _deleteMode = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.headlineMedium)),
                if (_deleteMode)
                  GestureDetector(
                    onTap: () => setState(() {
                      _deleteMode = false;
                      _error = null;
                    }),
                    behavior: HitTestBehavior.opaque,
                    child: Text('Done',
                        style: AppTypography.button.copyWith(color: Theme.of(context).colorScheme.primary)),
                  ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 6),
              Text(_error!, style: AppTypography.smallMonetary.copyWith(color: AppColors.negative)),
            ] else if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                _deleteMode ? 'Tap ✕ to remove' : widget.subtitle!,
                style: AppTypography.smallMonetary.copyWith(color: context.neutrals.textSecondary),
              ),
            ],
            const SizedBox(height: 18),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    for (final o in _options)
                      _DeletableChip(
                        label: widget.labelOf(o),
                        icon: widget.iconOf?.call(o),
                        iconColor: widget.colorOf?.call(o),
                        active: o == widget.selected,
                        showDelete: _deleteMode && _canDelete(o),
                        onTap: () => Navigator.pop(context, o),
                        onLongPress: _anyDeletable ? () => setState(() => _deleteMode = true) : null,
                        onDelete: () => _handleDelete(o),
                      ),
                    if (widget.onCreateNew != null && !_deleteMode)
                      _CreateChip(onTap: () async {
                        final created = await widget.onCreateNew!();
                        if (created != null && context.mounted) Navigator.pop(context, created);
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A [SquareChip] that, in delete mode, overlays a ✕ badge in its top-right
/// corner and does an iOS-style jiggle. Long-press anywhere on it enters delete
/// mode via [onLongPress].
class _DeletableChip extends StatefulWidget {
  const _DeletableChip({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.active,
    required this.showDelete,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool active;
  final bool showDelete;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onDelete;

  @override
  State<_DeletableChip> createState() => _DeletableChipState();
}

class _DeletableChipState extends State<_DeletableChip> with SingleTickerProviderStateMixin {
  late final AnimationController _wiggle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
  );

  // Desync neighbouring chips so the row doesn't jiggle in lockstep.
  late final bool _phase = widget.label.hashCode.isEven;

  @override
  void initState() {
    super.initState();
    if (widget.showDelete) _start();
  }

  @override
  void didUpdateWidget(_DeletableChip old) {
    super.didUpdateWidget(old);
    if (widget.showDelete && !old.showDelete) {
      _start();
    } else if (!widget.showDelete && old.showDelete) {
      _wiggle.stop();
      _wiggle.value = 0;
    }
  }

  void _start() {
    _wiggle.value = _phase ? 0 : 1;
    _wiggle.repeat(reverse: true);
  }

  @override
  void dispose() {
    _wiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chip = Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          // Room so the badge is not clipped by the Wrap's tight bounds.
          padding: const EdgeInsets.only(top: 6, right: 6),
          child: GestureDetector(
            onLongPress: widget.onLongPress,
            child: SquareChip(label: widget.label, icon: widget.icon, iconColor: widget.iconColor, active: widget.active, onTap: widget.onTap),
          ),
        ),
        if (widget.showDelete)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: widget.onDelete,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.negative,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.neutrals.surface, width: 1.5),
                ),
                child: const Icon(Icons.close_rounded, size: 13, color: Colors.white),
              ),
            ),
          ),
      ],
    );

    if (!widget.showDelete) return chip;
    return AnimatedBuilder(
      animation: _wiggle,
      // Oscillate a small rotation around the chip centre for the jiggle.
      builder: (context, child) => Transform.rotate(
        angle: (_wiggle.value - 0.5) * 0.08,
        child: child,
      ),
      child: chip,
    );
  }
}

/// Shows a modern month-calendar date picker in a bottom sheet and returns the
/// chosen day (or null on dismiss).
Future<DateTime?> showDatePickerSheet(
  BuildContext context, {
  required DateTime initial,
  required DateTime firstDate,
  required DateTime lastDate,
  bool hideYear = false,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => _CalendarSheet(initial: initial, firstDate: firstDate, lastDate: lastDate, hideYear: hideYear),
  );
}

class _CalendarSheet extends StatefulWidget {
  const _CalendarSheet({
    required this.initial,
    required this.firstDate,
    required this.lastDate,
    this.hideYear = false,
  });

  final DateTime initial;
  final DateTime firstDate;
  final DateTime lastDate;

  /// When true the year is never shown or selectable: the title reads just the
  /// month name and tapping it does nothing. Used for year-less pay/receive dates.
  final bool hideYear;

  @override
  State<_CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<_CalendarSheet> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  late DateTime _selected;
  late DateTime _visibleMonth;

  /// When true the body shows the year grid instead of the day grid, so the
  /// year can be picked separately from the month/day.
  bool _pickingYear = false;

  @override
  void initState() {
    super.initState();
    _selected = _dayOnly(widget.initial);
    _visibleMonth = DateTime(_selected.year, _selected.month);
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  /// Jumps to [year], keeping the currently selected month/day (clamped to a
  /// valid day and into the allowed range), then returns to the day grid.
  void _pickYear(int year) {
    final day = _selected.day > _daysInMonth(year, _selected.month)
        ? _daysInMonth(year, _selected.month)
        : _selected.day;
    var next = DateTime(year, _selected.month, day);
    if (next.isBefore(_dayOnly(widget.firstDate))) next = _dayOnly(widget.firstDate);
    if (next.isAfter(_dayOnly(widget.lastDate))) next = _dayOnly(widget.lastDate);
    setState(() {
      _selected = next;
      _visibleMonth = DateTime(next.year, next.month);
      _pickingYear = false;
    });
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  bool _inRange(DateTime d) {
    final lo = _dayOnly(widget.firstDate);
    final hi = _dayOnly(widget.lastDate);
    return !d.isBefore(lo) && !d.isAfter(hi);
  }

  bool get _canGoPrev => _inRange(DateTime(_visibleMonth.year, _visibleMonth.month, 0));

  bool get _canGoNext {
    final firstOfNext = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    return !_dayOnly(firstOfNext).isAfter(_dayOnly(widget.lastDate));
  }

  void _shiftMonth(int delta) {
    setState(() => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta));
  }

  /// The year grid shown when [_pickingYear] is on: every year in the allowed
  /// [firstDate, lastDate] range, the current one highlighted. Bounded and
  /// scrollable so a wide range never overflows the sheet.
  Widget _buildYearGrid(BuildContext context, Color primary) {
    final firstYear = widget.firstDate.year;
    final lastYear = widget.lastDate.year;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 288),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
        children: [
          for (var year = firstYear; year <= lastYear; year++)
            _YearCell(
              year: year,
              selected: year == _visibleMonth.year,
              primary: primary,
              onTap: () => _pickYear(year),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final today = _dayOnly(DateTime.now());

    // Leading blanks so the 1st lands under its weekday (Mon-first grid).
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 16),
            // Month/year title (tap to pick the year) + month navigation arrows.
            // With [hideYear] the year is dropped and the title is inert.
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.hideYear ? null : () => setState(() => _pickingYear = !_pickingYear),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.hideYear
                                ? _months[_visibleMonth.month - 1]
                                : '${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!widget.hideYear) ...[
                          const SizedBox(width: 6),
                          Icon(
                            _pickingYear ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                            size: 22,
                            color: context.neutrals.textSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (!_pickingYear) ...[
                  _NavArrow(icon: Icons.chevron_left_rounded, onTap: _canGoPrev ? () => _shiftMonth(-1) : null),
                  const SizedBox(width: 8),
                  _NavArrow(icon: Icons.chevron_right_rounded, onTap: _canGoNext ? () => _shiftMonth(1) : null),
                ],
              ],
            ),
            const SizedBox(height: 18),
            if (_pickingYear)
              _buildYearGrid(context, primary)
            else ...[
              // Weekday header.
              Row(
                children: [
                  for (final w in _weekdays)
                    Expanded(
                      child: Center(
                        child: Text(
                          w,
                          style: AppTypography.badge.copyWith(color: context.neutrals.textFaint),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Day grid.
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
                  for (var day = 1; day <= daysInMonth; day++)
                    _DayCell(
                      day: day,
                      date: DateTime(_visibleMonth.year, _visibleMonth.month, day),
                      selected: _sameDay(_selected, DateTime(_visibleMonth.year, _visibleMonth.month, day)),
                      isToday: _sameDay(today, DateTime(_visibleMonth.year, _visibleMonth.month, day)),
                      enabled: _inRange(DateTime(_visibleMonth.year, _visibleMonth.month, day)),
                      primary: primary,
                      onTap: () => setState(
                        () => _selected = DateTime(_visibleMonth.year, _visibleMonth.month, day),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                if (_inRange(today))
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SquareChip(
                      label: 'Today',
                      active: false,
                      onTap: () => setState(() {
                        _selected = today;
                        _visibleMonth = DateTime(today.year, today.month);
                        _pickingYear = false;
                      }),
                    ),
                  ),
                Expanded(
                  child: PrimaryButton(
                    label: 'Select',
                    onTap: () => Navigator.pop(context, _selected),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A round navigation button used by the calendar header (dimmed when disabled).
class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: context.neutrals.surfaceHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.neutrals.surfaceHigh),
        ),
        child: Icon(icon, size: 22, color: enabled ? context.neutrals.textPrimary : context.neutrals.textFaint),
      ),
    );
  }
}

/// A single day in the calendar grid. Selected days get a filled primary
/// circle; today (unselected) gets a subtle primary ring.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.date,
    required this.selected,
    required this.isToday,
    required this.enabled,
    required this.primary,
    required this.onTap,
  });

  final int day;
  final DateTime date;
  final bool selected;
  final bool isToday;
  final bool enabled;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (!enabled) {
      textColor = context.neutrals.textFaint;
    } else if (selected) {
      textColor = Colors.white;
    } else if (isToday) {
      textColor = primary;
    } else {
      textColor = context.neutrals.textPrimary;
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? primary : Colors.transparent,
          border: !selected && isToday ? Border.all(color: primary.withValues(alpha: 0.5), width: 1.5) : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: AppTypography.body.copyWith(
              color: textColor,
              fontWeight: selected || isToday ? AppTypography.bold : AppTypography.medium,
            ),
          ),
        ),
      ),
    );
  }
}

/// A single year in the year-picker grid. The current year gets a filled
/// primary chip; the rest sit on a soft raised surface.
class _YearCell extends StatelessWidget {
  const _YearCell({
    required this.year,
    required this.selected,
    required this.primary,
    required this.onTap,
  });

  final int year;
  final bool selected;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? primary : context.neutrals.surfaceHigh,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          '$year',
          style: AppTypography.body.copyWith(
            color: selected ? Colors.white : context.neutrals.textPrimary,
            fontWeight: selected ? AppTypography.bold : AppTypography.medium,
          ),
        ),
      ),
    );
  }
}

/// A create sheet with a logo (icon) picker, a name field, and a Save button.
/// Returns the chosen name + icon key, or null on dismiss.
Future<({String name, String iconKey})?> showCreateItemSheet(BuildContext context, {required String title}) {
  return showModalBottomSheet<({String name, String iconKey})>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _CreateItemSheet(title: title),
    ),
  );
}

/// Shows a minimal sheet with a single name field and a Save button, returning
/// the entered text (trimmed) or null on dismiss. Used for simple named items
/// like payment cards that need no icon.
Future<String?> showTextEntrySheet(
  BuildContext context, {
  required String title,
  required String label,
  String? hint,
  String saveLabel = 'Save',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _TextEntrySheet(title: title, label: label, hint: hint, saveLabel: saveLabel),
    ),
  );
}

class _TextEntrySheet extends StatefulWidget {
  const _TextEntrySheet({required this.title, required this.label, this.hint, required this.saveLabel});
  final String title;
  final String label;
  final String? hint;
  final String saveLabel;

  @override
  State<_TextEntrySheet> createState() => _TextEntrySheetState();
}

class _TextEntrySheetState extends State<_TextEntrySheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 16),
            Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 18),
            LabeledField(
              label: widget.label,
              controller: _controller,
              hint: widget.hint,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => PrimaryButton(
                label: widget.saveLabel,
                onTap: _controller.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, _controller.text.trim()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet for creating or recolouring a payment card: a name field followed by
/// a colour picker. Returns the entered name (trimmed) plus the chosen colour,
/// or null on dismiss. When [initialName] is given the name is shown read-only
/// (recolouring an existing card, whose name other entries reference by value).
Future<({String name, Color color})?> showCardSheet(
  BuildContext context, {
  String? initialName,
  Color? initialColor,
}) {
  return showModalBottomSheet<({String name, Color color})>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _CardSheet(initialName: initialName, initialColor: initialColor),
    ),
  );
}

class _CardSheet extends StatefulWidget {
  const _CardSheet({this.initialName, this.initialColor});
  final String? initialName;
  final Color? initialColor;

  @override
  State<_CardSheet> createState() => _CardSheetState();
}

class _CardSheetState extends State<_CardSheet> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialName ?? '');
  late Color _color = widget.initialColor ?? AppColors.cardPalette.first;

  // An existing card is recoloured, not renamed - other entries reference it by
  // name, so the field is locked once we're editing one.
  bool get _editing => widget.initialName != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 16),
            Text(_editing ? 'Card colour' : 'New card', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 18),
            if (_editing)
              // Read-only preview of the card being recoloured.
              Row(
                children: [
                  Icon(Icons.credit_card_rounded, size: 22, color: _color),
                  const SizedBox(width: 12),
                  Text(widget.initialName!,
                      style: AppTypography.body.copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium)),
                ],
              )
            else
              LabeledField(
                label: 'Card name',
                controller: _controller,
                hint: 'e.g. Revolut',
                textCapitalization: TextCapitalization.words,
              ),
            const SizedBox(height: 22),
            _FieldLabel('Colour'),
            const SizedBox(height: 12),
            _ColorSwatchRow(
              colors: AppColors.cardPalette,
              selected: _color,
              onSelect: (c) => setState(() => _color = c),
            ),
            const SizedBox(height: 22),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => PrimaryButton(
                label: 'Save',
                onTap: _controller.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, (name: _controller.text.trim(), color: _color)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A wrapping row of colour swatches (5 per row), the selected one ringed and
/// ticked. Shared by the card sheet; a general building block for colour picks.
class _ColorSwatchRow extends StatelessWidget {
  const _ColorSwatchRow({required this.colors, required this.selected, required this.onSelect});
  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelect;

  @override
  Widget build(BuildContext context) {
    const columns = 5;
    const spacing = 12.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final c in colors)
              GestureDetector(
                onTap: () => onSelect(c),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(14),
                    border: c.toARGB32() == selected.toARGB32()
                        ? Border.all(color: context.neutrals.textPrimary, width: 3)
                        : null,
                  ),
                  child: c.toARGB32() == selected.toARGB32()
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CreateChip extends StatelessWidget {
  const _CreateChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 17, color: primary),
            const SizedBox(width: 6),
            Text('Create your own',
                style: AppTypography.subtitle.copyWith(color: primary, fontWeight: AppTypography.medium)),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(color: context.neutrals.surfaceHigh, borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}

class _CreateItemSheet extends StatefulWidget {
  const _CreateItemSheet({required this.title});
  final String title;

  @override
  State<_CreateItemSheet> createState() => _CreateItemSheetState();
}

class _CreateItemSheetState extends State<_CreateItemSheet> {
  final _controller = TextEditingController();
  String _iconKey = defaultIconKey;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final picked = await showIconPickerSheet(context, selectedKey: _iconKey);
    final key = picked?.iconKey;
    if (key != null) setState(() => _iconKey = key);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 8),
            // Close (left) + centred title, matching the reference layout.
            Row(
              children: [
                _CircleIconButton(icon: Icons.close_rounded, onTap: () => Navigator.pop(context)),
                Expanded(
                  child: Center(
                    child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                const SizedBox(width: 38), // balances the close button
              ],
            ),
            const SizedBox(height: 8),
            // The big, tappable focal icon sitting over a faded icon spray.
            _IconHero(iconKey: _iconKey, onTap: _pickIcon),
            const SizedBox(height: 20),
            LabeledField(
              label: 'Name',
              controller: _controller,
              hint: 'e.g. Groceries',
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => PrimaryButton(
                label: 'Save',
                onTap: _controller.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, (name: _controller.text.trim(), iconKey: _iconKey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The large focal icon shown at the top of the create sheet: the chosen icon
/// on a soft primary disc, floating over a faded scatter of other icons. Tap to
/// open the icon picker.
class _IconHero extends StatelessWidget {
  const _IconHero({required this.iconKey, required this.onTap});
  final String iconKey;
  final VoidCallback onTap;

  // A fixed decorative scatter, drawn faintly behind the focal disc.
  static const _scatter = [
    'wallet', 'coffee', 'car', 'gift', 'heart', 'music', 'camera', 'plane',
    'book', 'star', 'pizza', 'bike', 'gamepad2', 'leaf', 'trophy', 'shoppingBag',
    'home', 'sun', 'dog', 'flame', 'umbrella', 'key', 'bell', 'ticket',
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 150,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Faded scatter backdrop.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: 0.10,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    for (final k in _scatter)
                      Icon(iconForKey(k), size: 26, color: context.neutrals.textPrimary),
                  ],
                ),
              ),
            ),
            // Focal disc.
            GestureDetector(
              onTap: onTap,
              child: IconMedallion(icon: iconForKey(iconKey), color: primary, size: 96, iconSize: 42),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small circular icon button (used for the create sheet's close action).
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: context.neutrals.surfaceHigh, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: context.neutrals.textPrimary),
      ),
    );
  }
}

// ----- Icon picker -----

/// The outcome of the icon picker: either a chosen Lucide [iconKey] or a chosen
/// brand [logoUrl]. Exactly one is set; the caller applies whichever it is.
class IconPickResult {
  const IconPickResult.icon(String this.iconKey) : logoUrl = null;
  const IconPickResult.logo(String this.logoUrl) : iconKey = null;
  final String? iconKey;
  final String? logoUrl;
}

/// Opens the categorized, searchable icon picker (Lucide icons) as a tall modal
/// sheet and returns the chosen icon, or null on dismiss. [selectedKey]
/// highlights the current icon. When [allowLogo] is true the sheet also offers a
/// Logo tab: search a brand and pick its logo (returned as [IconPickResult.logo]).
Future<IconPickResult?> showIconPickerSheet(
  BuildContext context, {
  String? selectedKey,
  bool allowLogo = false,
}) {
  return showModalBottomSheet<IconPickResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => _IconPickerSheet(selectedKey: selectedKey, allowLogo: allowLogo),
  );
}

class _IconPickerSheet extends StatefulWidget {
  const _IconPickerSheet({this.selectedKey, this.allowLogo = false});
  final String? selectedKey;
  final bool allowLogo;

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  final _search = TextEditingController();
  bool _searching = false;

  // Logo tab state.
  bool _logoMode = false;
  final _logoQuery = TextEditingController();
  final _logoService = locator<LogoService>();
  bool _logoLoading = false;
  bool _logoSearched = false; // whether a search has run (drives the empty state)
  List<String> _logoResults = const [];

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    _logoQuery.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) _search.clear();
    });
  }

  void _setLogoMode(bool logo) {
    if (_logoMode == logo) return;
    setState(() {
      _logoMode = logo;
      if (logo) _searching = false; // the two search fields don't coexist
    });
  }

  Future<void> _runLogoSearch() async {
    final query = _logoQuery.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _logoLoading = true);
    final results = await _logoService.searchLogos(query);
    if (!mounted) return;
    setState(() {
      _logoResults = results;
      _logoLoading = false;
      _logoSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text;
    final results = query.trim().isEmpty ? null : searchIcons(query);
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 12),
              Row(
                children: [
                  _CircleIconButton(icon: Icons.chevron_left_rounded, onTap: () => Navigator.pop(context)),
                  Expanded(
                    child: Center(
                      // Searching (icon tab) takes over the header; otherwise show
                      // the Icon|Logo toggle (when logos are allowed) or the title.
                      child: _searching
                          ? _SearchField(controller: _search)
                          : (widget.allowLogo
                              ? _IconLogoToggle(logoMode: _logoMode, onChanged: _setLogoMode)
                              : _titlePill(context, 'Icon')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // The search toggle only applies to the Icon tab; the Logo tab
                  // carries its own always-visible search field.
                  if (!_logoMode)
                    _CircleIconButton(
                      icon: _searching ? Icons.close_rounded : Icons.search_rounded,
                      onTap: _toggleSearch,
                    )
                  else
                    const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _logoMode
                    ? _buildLogo(context)
                    : (results == null
                        ? _buildBrowse(context)
                        : _buildResults(context, results)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titlePill(BuildContext context, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text,
            style: AppTypography.subtitle
                .copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium)),
      );

  // The Logo tab: a brand search field and a grid of resolved logo tiles.
  Widget _buildLogo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: context.neutrals.surfaceHigh,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 18, color: context.neutrals.textFaint),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _logoQuery,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _runLogoSearch(),
                  style: AppTypography.body.copyWith(color: context.neutrals.textPrimary),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Search a brand (e.g. Netflix)',
                    hintStyle: TextStyle(color: context.neutrals.textFaint),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildLogoBody(context)),
      ],
    );
  }

  Widget _buildLogoBody(BuildContext context) {
    if (_logoLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_logoSearched) {
      return _logoHint(context, 'Type a brand name and press search.');
    }
    if (_logoResults.isEmpty) {
      return _logoHint(context, 'No logos found. Try the full name or a domain.');
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 12),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final url in _logoResults)
              GestureDetector(
                onTap: () => Navigator.pop(context, IconPickResult.logo(url)),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: context.neutrals.surfaceHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: EntryAvatar(
                    logoUrl: url,
                    icon: Icons.image_rounded,
                    color: context.neutrals.surfaceHigh,
                    size: 48,
                    iconSize: 24,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _logoHint(BuildContext context, String text) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(text,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: context.neutrals.textSecondary)),
        ),
      );

  // Category sections shown before searching.
  Widget _buildBrowse(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 12),
      children: [
        for (final cat in iconCategories) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 0, 12),
            child: Text(cat.name.toUpperCase(),
                style: AppTypography.badge.copyWith(color: context.neutrals.textFaint, letterSpacing: 1.2)),
          ),
          _IconWrap(keys: cat.keys, selectedKey: widget.selectedKey),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildResults(BuildContext context, List<String> keys) {
    if (keys.isEmpty) {
      return Center(
        child: Text('No icons found',
            style: AppTypography.body.copyWith(color: context.neutrals.textSecondary)),
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 12),
      children: [_IconWrap(keys: keys, selectedKey: widget.selectedKey)],
    );
  }
}

/// The Icon | Logo segmented toggle shown in the picker header when logos are
/// allowed, letting the user switch between the Lucide grid and brand-logo search.
class _IconLogoToggle extends StatelessWidget {
  const _IconLogoToggle({required this.logoMode, required this.onChanged});
  final bool logoMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.neutrals.surfaceHigh,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment(context, 'Icon', !logoMode, () => onChanged(false)),
          _segment(context, 'Logo', logoMode, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, String label, bool active, VoidCallback onTap) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: active ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTypography.subtitle.copyWith(
            color: active ? Colors.white : context.neutrals.textSecondary,
            fontWeight: AppTypography.medium,
          ),
        ),
      ),
    );
  }
}

/// A wrapping grid of icon tiles. Tapping a tile pops the sheet with its key.
class _IconWrap extends StatelessWidget {
  const _IconWrap({required this.keys, required this.selectedKey});
  final List<String> keys;
  final String? selectedKey;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final key in keys)
          GestureDetector(
            onTap: () => Navigator.pop(context, IconPickResult.icon(key)),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: key == selectedKey ? primary.withValues(alpha: 0.16) : context.neutrals.surfaceHigh,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: key == selectedKey ? primary : context.neutrals.surfaceHigh,
                  width: key == selectedKey ? 1.5 : 1,
                ),
              ),
              child: Icon(iconForKey(key), color: context.neutrals.textPrimary, size: 24),
            ),
          ),
      ],
    );
  }
}

/// The inline search field shown in the icon picker header when searching.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.neutrals.surfaceHigh,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          autofocus: true,
          style: AppTypography.body.copyWith(color: context.neutrals.textPrimary),
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: 'Search icons',
            hintStyle: TextStyle(color: context.neutrals.textFaint),
          ),
        ),
      ),
    );
  }
}
