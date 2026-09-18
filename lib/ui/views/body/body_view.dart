import 'package:flutter/material.dart';

import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';

/// Placeholder Body-measurements tab. For now it only sits behind the shared
/// floating top bar; the dedicated body-tracking UI comes later.
class BodyView extends StatelessWidget {
  const BodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.accessibility_new_rounded, size: 40, color: context.neutrals.textFaint),
            const SizedBox(height: 12),
            Text('Body measurements',
                style: AppTypography.listItemTitle.copyWith(color: context.neutrals.textSecondary)),
          ],
        ),
      ),
    );
  }
}
