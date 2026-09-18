const _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Formats an ISO `yyyy-MM-dd` string as a friendly `d MMM yyyy` (e.g.
/// "23 Aug 2026"). Returns the input unchanged if it cannot be parsed.
String formatIsoDate(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';
}

/// Formats an ISO `yyyy-MM-dd` string as a year-less `DD-MMM` (e.g. "24-Aug").
/// Used for pay/receive dates, where only the day and month matter. Returns the
/// input unchanged if it cannot be parsed.
String formatDayMonth(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.day.toString().padLeft(2, '0')}-${_monthsShort[d.month - 1]}';
}

/// Formats a [DateTime] as a friendly `d MMM yyyy, HH:mm` in local time (e.g.
/// "23 Aug 2026, 14:05"). Used for the created / updated history rows.
String formatDateTime(DateTime d) {
  final local = d.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '${local.day} ${_monthsShort[local.month - 1]} ${local.year}, $hh:$mm';
}
