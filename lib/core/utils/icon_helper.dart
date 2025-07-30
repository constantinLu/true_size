import 'package:flutter/material.dart';

class MeasurementIconHelper {
  static const Map<String, IconData> _icons = {
// Measurement tools
    'straighten': Icons.straighten,
    'ruler': Icons.straighten,
    'measure': Icons.architecture,
    'tape_measure': Icons.format_size,

// Dimension types
    'height': Icons.height,
    'width': Icons.width_normal_outlined,
    'length': Icons.square_foot,
    'depth': Icons.layers,
    'diameter': Icons.circle_outlined,
    'radius': Icons.radio_button_unchecked,
    'area': Icons.crop_square,
    'volume': Icons.view_in_ar,
    'perimeter': Icons.square_outlined,

// Common measurements
    'door': Icons.door_sliding,
    'window': Icons.window,
    'wall': Icons.rectangle,
    'floor': Icons.grid_4x4,
    'ceiling': Icons.horizontal_rule,
    'furniture': Icons.chair,
    'appliance': Icons.kitchen,
    'room': Icons.meeting_room,

// Tools & Equipment
    'camera': Icons.camera_alt,
    'phone': Icons.phone_android,
    'tablet': Icons.tablet,
    'laser': Icons.highlight,
    'manual': Icons.pan_tool,

// Categories
    'home': Icons.home,
    'office': Icons.business,
    'outdoor': Icons.outdoor_grill,
    'vehicle': Icons.directions_car,
    'sport': Icons.sports,
    'craft': Icons.build,

// General
    'custom': Icons.tune,
    'other': Icons.more_horiz,
    'default': Icons.straighten,
  };

  static IconData getIcon(String iconName) {
    return _icons[iconName] ?? Icons.straighten; // Default measurement icon
  }

  static List<String> get availableIcons => _icons.keys.toList();

  static List<MapEntry<String, IconData>> get iconEntries =>
      _icons.entries.toList();

// Get icons by category for UI organization
  static List<String> get measurementTools =>
      ['straighten', 'ruler', 'measure', 'tape_measure'];

  static List<String> get dimensionTypes => [
        'height',
        'width',
        'length',
        'depth',
        'diameter',
        'radius',
        'area',
        'volume',
        'perimeter'
      ];

  static List<String> get commonItems => [
        'door',
        'window',
        'wall',
        'floor',
        'ceiling',
        'furniture',
        'appliance',
        'room'
      ];

  static List<String> get toolsEquipment =>
      ['camera', 'phone', 'tablet', 'laser', 'manual'];

  static List<String> get categories =>
      ['home', 'office', 'outdoor', 'vehicle', 'sport', 'craft'];
}
