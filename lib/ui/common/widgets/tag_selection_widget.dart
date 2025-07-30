// import 'package:flutter/material.dart';
// import 'package:true_size/ui/common/widgets/tag_widget.dart';
//
// import '../../views/add_measurement/add_group_form_viewmodel.dart';
// import '../palette.dart';
//
// class TagSelectionWidget extends StatelessWidget {
//   const TagSelectionWidget({
//     super.key,
//     required this.viewModel,
//   });
//
//   final AddGroupFormViewModel viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Tags',
//           style: TextStyle(
//             color: whiteCultured,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         // Selected tags as tiles
//         if (viewModel.selectedTags.isNotEmpty) ...[
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: viewModel.selectedTags.map((tag) {
//               return TileWidget(
//                 label: tag.name,
//                 onTap: () => viewModel.removeTag(tag),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 10),
//           const Divider(
//             color: Palette.whiteCultured,
//           ),
//         ],
//
//         // Add tag tile
//         GestureDetector(
//           onTap: viewModel.showTagSelector,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Palette.buttonColor,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Palette.backgroundColor),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.add, color: Palette.whiteCultured, size: 20),
//                 SizedBox(width: 12),
//                 Text(
//                   'Add Tag',
//                   style: TextStyle(
//                     color: Palette.whiteCultured,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
