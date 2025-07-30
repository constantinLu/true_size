// import 'package:flutter/material.dart';
//
// import '../../ui/common/sheet_helper.dart';
//
// class CreateBrandSheet extends StatelessWidget {
//   final String selectedIcon;
//   final Function(String) onSave;
//   final VoidCallback onBack;
//   final VoidCallback onIconSelect;
//
//   const CreateBrandSheet({
//     required this.selectedIcon,
//     required this.onSave,
//     required this.onBack,
//     required this.onIconSelect,
//   });
//
//   static Future<void> show({
//     required BuildContext context,
//     required String selectedIcon,
//     required Function(String) onSave,
//     required VoidCallback onBack,
//     required VoidCallback onIconSelect,
//   }) {
//     return showCustomBottomSheet(
//       title: 'Create Brand',
//       subtitle: 'Create brand. Choose an icon and enter a name',
//       child: CreateBrandSheet(
//         selectedIcon: selectedIcon,
//         onSave: onSave,
//         onBack: onBack,
//         onIconSelect: onIconSelect,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController controller = TextEditingController();
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildInputRow(controller),
//           const SizedBox(height: 16),
//           _buildActionButtons(controller),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputRow(TextEditingController controller) {
//     // ... Input row implementation
//     return null;
//   }
//
//   Widget _buildActionButtons(TextEditingController controller) {
//     // ... Action buttons implementation
//     retun null;
//   }
// }
