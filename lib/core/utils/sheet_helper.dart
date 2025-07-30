import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> showCustomBottomSheet({
  required String title,
  String? subtitle,
  required Widget child,
}) async {
  await showModalBottomSheet(
    context: StackedService.navigatorKey!.currentContext!,
    backgroundColor: const Color(0xFF1C1C1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: 90.sp,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4.sp,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Flexible(
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildSelectableTile({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withOpacity(0.2)
            : const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showIconSelectorBottomSheet({
  required String title,
  required List<String> icons,
  required Function(String) onIconSelected,
}) async {
  final iconDataMap = {
    'straighten': Icons.straighten,
    'fitness_center': Icons.fitness_center,
    'accessibility_new': Icons.accessibility_new,
    'favorite': Icons.favorite,
    'monitor_weight': Icons.monitor_weight,
    'scale': Icons.scale,
    'directions_run': Icons.directions_run,
    'pool': Icons.pool,
    'sports_basketball': Icons.sports_basketball,
    'sports_soccer': Icons.sports_soccer,
    'thermostat': Icons.thermostat,
    'speed': Icons.speed,
  };

  await showCustomBottomSheet(
    title: title,
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final iconName = icons[index];
        final iconData = iconDataMap[iconName] ?? Icons.help;
        return GestureDetector(
          onTap: () {
            onIconSelected(iconName);
            //navigationService.back();
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              size: 24,
              color: Colors.white,
            ),
          ),
        );
      },
    ),
  );
}

// Future<void> _showUnitSelectionBottomSheet({
//   Unit? selectedUnit,
//   required Function(Unit) onUnitSelected,
// }) async {
//   await showCustomBottomSheet(
//     title: 'Select Unit',
//     child: Column(
//       children: [
//         // Predefined units
//         ...Unit.values.map((unit) {
//           final isSelected = selectedUnit == unit;
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             child: ListTile(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               tileColor: const Color(0xFF2C2C2E),
//               title: Text(
//                 '${unit.displayName} (${unit.symbol})',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                 ),
//               ),
//               trailing: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
//               onTap: () {
//                 onUnitSelected(unit);
//                 navigationService.back();
//               },
//             ),
//           );
//         }).toList(),
//       ],
//     ),
//   );
// }
//
// Future<void> _showTagSelectionBottomSheet({
//   required List<Tag> availableTags,
//   required Function(Tag) onTagSelected,
//   required Function(String) onNewTagCreated,
// }) async {
//   await showCustomBottomSheet(
//     title: 'Tags',
//     subtitle: 'Pick one or multiple tags that your group fits in',
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Tags wrap
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               // Regular tag tiles
//               ...availableTags.map((tag) {
//                 final isSelected = _selectedTags.contains(tag);
//                 return buildSelectableTile(
//                   icon: Icons.tag,
//                   label: tag.name,
//                   isSelected: isSelected,
//                   onTap: () {
//                     onTagSelected(tag);
//                     // Don't close for multi-selection, just update the UI
//                   },
//                 );
//               }),
//
//               // Create your own tile
//               buildSelectableTile(
//                 icon: Icons.add,
//                 label: 'Create your own',
//                 isSelected: false,
//                 onTap: () {
//                   navigationService.back();
//                   _showCreateCustomTagBottomSheet(onNewTagCreated);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Future<void> _showCreateCustomTagBottomSheet(Function(String) onNewTagCreated) async {
//   final TextEditingController controller = TextEditingController();
//
//   await showCustomBottomSheet(
//     title: 'Create Tag',
//     subtitle: 'Create a completely new tag. Enter a name',
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Text field
//           TextFormField(
//             controller: controller,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: 'Fitness, Finance, Personal, ...',
//               hintStyle: const TextStyle(color: Colors.grey),
//               filled: true,
//               fillColor: const Color(0xFF2C2C2E),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Action buttons
//           Row(
//             children: [
//               // Back button
//               Expanded(
//                 child: Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2C2C2E),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: TextButton(
//                     onPressed: () => navigationService.back(),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // Save button
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (controller.text.trim().isNotEmpty) {
//                         onNewTagCreated(controller.text.trim());
//                         //navigationService.back();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: null,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Save',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
