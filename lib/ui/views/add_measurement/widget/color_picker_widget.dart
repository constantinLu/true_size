import 'package:flutter/material.dart';

import '../../../common/palette.dart';
import '../add_group_form_viewmodel.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    super.key,
    required this.viewModel,
  });

  final AddGroupFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFF3B30),
      const Color(0xFFFF9500),
      const Color(0xFFFFCC02),
      const Color(0xFFFFD60A),
      const Color(0xFF30D158),
      const Color(0xFF40C8E0),
      const Color(0xFF64D2FF),
      const Color(0xFF007AFF),
      const Color(0xFF5856D6),
      const Color(0xFFAF52DE),
      const Color(0xFFFF2D92),
      const Color(0xFF8E8E93),
      const Color(0xFF636366),
      const Color(0xFF48484A),
      const Color(0xFF3A3A3C),
      const Color(0xFF1C1C1E),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            color: whiteCultured,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            final isSelected =
                viewModel.selectedColorValue.value == color.value;
            return GestureDetector(
              onTap: () => viewModel.selectColor(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(8), // Squared with rounded corners
                  border: isSelected
                      ? Border.all(color: whiteCultured, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
