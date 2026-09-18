import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'lucide_catalog.g.dart';

/// Icon system for categories and labels.
///
/// Icons are stored on the Firestore document by a stable string key. New
/// entries store a Lucide icon name directly (e.g. `shoppingCart`); the full
/// set lives in [lucideIcons] (generated). Older documents stored a small set
/// of curated keys ([_legacyAliases]) which are mapped onto their Lucide
/// equivalents so existing data keeps rendering after the switch to Lucide.

/// Maps the pre-Lucide curated keys (still stored on old documents and on the
/// seeded default categories/labels) to their Lucide equivalents.
const Map<String, String> _legacyAliases = {
  'tag': 'tag',
  'home': 'home',
  'bolt': 'zap',
  'play': 'play',
  'cloud': 'cloud',
  'coffee': 'coffee',
  'restaurant': 'utensils',
  'fuel': 'fuel',
  'car': 'car',
  'flight': 'plane',
  'heart': 'heart',
  'health': 'stethoscope',
  'cut': 'scissors',
  'fitness': 'dumbbell',
  'shield': 'shield',
  'bank': 'landmark',
  'wallet': 'wallet',
  'pay': 'banknote',
  'apartment': 'building2',
  'work': 'briefcase',
  'school': 'school',
  'pet': 'dog',
  'gift': 'gift',
  'phone': 'smartphone',
  'shopping': 'shoppingBag',
  'star': 'star',
};

/// Resolves an icon key to its [IconData]. Tries the Lucide set first, then the
/// legacy alias map, falling back to a generic tag so the UI is never empty.
IconData iconForKey(String? key) {
  if (key == null) return LucideIcons.tag;
  return lucideIcons[key] ?? lucideIcons[_legacyAliases[key]] ?? LucideIcons.tag;
}

/// A named, curated group of icon keys shown as a section in the picker's
/// browse view. Search spans the whole [lucideIcons] set, not just these.
typedef IconCategory = ({String name, List<String> keys});

/// The browse sections shown in the icon picker (before searching). Curated so
/// the common cases are one tap away; the search box reaches every Lucide icon.
const List<IconCategory> iconCategories = [
  (name: 'Finance', keys: [
    'wallet', 'banknote', 'creditCard', 'piggyBank', 'landmark', 'coins',
    'dollarSign', 'euro', 'poundSterling', 'receipt', 'calculator',
    'trendingUp', 'trendingDown', 'badgeDollarSign', 'arrowLeftRight', 'scale',
  ]),
  (name: 'Home', keys: [
    'home', 'bed', 'bath', 'sofa', 'lamp', 'doorOpen', 'key', 'armchair',
    'refrigerator', 'plug', 'wrench', 'hammer', 'paintbrush', 'brush',
    'trash2', 'anchor',
  ]),
  (name: 'Food & Drink', keys: [
    'coffee', 'utensils', 'utensilsCrossed', 'pizza', 'beer', 'wine',
    'iceCream', 'cake', 'cookie', 'apple', 'cherry', 'carrot', 'egg', 'fish',
    'beef', 'salad', 'soup', 'sandwich', 'milk', 'cupSoda', 'popcorn', 'candy',
  ]),
  (name: 'Transport', keys: [
    'car', 'bus', 'train', 'plane', 'bike', 'fuel', 'ship', 'truck',
    'footprints', 'parkingCircle', 'sailboat', 'rocket',
  ]),
  (name: 'Shopping', keys: [
    'shoppingBag', 'shoppingCart', 'store', 'tag', 'tags', 'gift', 'package',
    'shirt', 'gem', 'glasses', 'watch',
  ]),
  (name: 'Health', keys: [
    'heart', 'heartPulse', 'activity', 'stethoscope', 'pill', 'cross',
    'syringe', 'thermometer', 'brain', 'dumbbell',
  ]),
  (name: 'Tech', keys: [
    'smartphone', 'laptop', 'tv', 'monitor', 'mouse', 'keyboard', 'headphones',
    'camera', 'printer', 'wifi', 'bluetooth', 'batteryCharging', 'cpu',
    'hardDrive', 'server', 'gamepad2', 'joystick',
  ]),
  (name: 'Entertainment', keys: [
    'music', 'film', 'clapperboard', 'ticket', 'mic', 'radio', 'book',
    'bookOpen', 'palette', 'partyPopper',
  ]),
  (name: 'Work & School', keys: [
    'briefcase', 'graduationCap', 'school', 'penTool', 'pencil', 'calendar',
    'clipboard', 'presentation', 'folder', 'mail', 'phone', 'building2',
  ]),
  (name: 'Nature', keys: [
    'leaf', 'trees', 'flower2', 'sun', 'moon', 'cloud', 'cloudRain',
    'snowflake', 'droplet', 'flame', 'mountain', 'wind', 'sprout', 'treePine',
    'bug', 'bird',
  ]),
  (name: 'People', keys: [
    'user', 'users', 'baby', 'userPlus', 'contact', 'smile', 'heartHandshake',
    'personStanding', 'accessibility', 'dog', 'cat',
  ]),
  (name: 'Sports & Travel', keys: [
    'trophy', 'medal', 'target', 'award', 'flag', 'tent', 'mountainSnow',
    'waves', 'map', 'mapPin', 'compass', 'globe', 'umbrella', 'hotel',
  ]),
  (name: 'Utilities', keys: [
    'wifi', 'globe', 'zap', 'plug', 'droplet', 'waves', 'flame', 'fuel',
    'thermometer', 'trash2', 'signal', 'router',
  ]),
  (name: 'Objects', keys: [
    'star', 'bell', 'clock', 'alarmClock', 'lightbulb', 'lock', 'shield',
    'bookmark', 'paperclip', 'scissors', 'magnet', 'zap',
  ]),
];

/// Everyday search terms that don't appear literally in a Lucide icon name,
/// mapped to the keys a user most likely means. Lets a search for "electricity"
/// surface `zap`, "water" surface `droplet`, and so on - so the catalog stops
/// feeling empty for common concepts. Every target must exist in [lucideIcons].
const Map<String, List<String>> _iconSynonyms = {
  'internet': ['wifi', 'globe', 'router', 'signal'],
  'wifi': ['wifi', 'signal', 'router'],
  'electricity': ['zap', 'plug', 'lightbulb'],
  'power': ['zap', 'plug', 'batteryCharging'],
  'utilities': ['zap', 'plug', 'droplet', 'flame', 'wifi'],
  'water': ['droplet', 'waves'],
  'gas': ['flame', 'fuel'],
  'heating': ['flame', 'thermometer'],
  'cash': ['banknote', 'wallet', 'coins', 'dollarSign'],
  'money': ['banknote', 'wallet', 'coins', 'dollarSign', 'badgeDollarSign'],
  'salary': ['banknote', 'wallet', 'coins'],
  'hospital': ['hospital', 'cross', 'stethoscope', 'building2'],
  'health': ['heartPulse', 'stethoscope', 'activity', 'pill', 'cross'],
  'medical': ['stethoscope', 'pill', 'syringe', 'cross'],
  'gaming': ['gamepad2', 'joystick'],
  'game': ['gamepad2', 'joystick'],
  'rent': ['home', 'key', 'building2'],
  'phone': ['smartphone', 'phone'],
  'trash': ['trash2'],
  'garbage': ['trash2'],
};

/// A sensible default icon key for a freshly opened create sheet.
const String defaultIconKey = 'tag';

/// Case-insensitive search across every Lucide icon name plus a small set of
/// everyday [_iconSynonyms] (so "electricity" finds `zap`, "water" finds
/// `droplet`, etc). Synonym matches are listed first, then substring name
/// matches; spaces in the query are ignored so "shopping cart" matches
/// "shoppingCart". Results are de-duplicated, preserving that order.
List<String> searchIcons(String query) {
  final q = query.trim().toLowerCase().replaceAll(' ', '');
  if (q.isEmpty) return const [];
  final seen = <String>{};
  final results = <String>[];
  void add(String key) {
    if (lucideIcons.containsKey(key) && seen.add(key)) results.add(key);
  }

  // Synonym terms whose word contains (or is contained by) the query, most
  // relevant first, so a concept search lands on the right icons up top.
  for (final entry in _iconSynonyms.entries) {
    if (entry.key.contains(q) || q.contains(entry.key)) {
      entry.value.forEach(add);
    }
  }
  for (final k in lucideIcons.keys) {
    if (k.toLowerCase().contains(q)) add(k);
  }
  return results;
}
