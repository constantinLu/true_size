import 'package:flutter/material.dart';

import '../../views/add_measurement/add_group_form_viewmodel.dart';
import '../palette.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.viewModel,
  });

  final AddGroupFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      //viewModel.addMeasurement,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Palette.buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Palette.backgroundColor),
        ),
        child: const Row(
          children: [
            Icon(Icons.add, color: Palette.whiteCultured, size: 20),
            SizedBox(width: 12),
            Text(
              'Add Measurement',
              style: TextStyle(
                color: Palette.whiteCultured,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
