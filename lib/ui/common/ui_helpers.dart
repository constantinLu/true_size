import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class UIHelpers {
  static const Widget verticalSpaceSmall = SizedBox(height: AppSizes.paddingSmall);
  static const Widget verticalSpaceMedium = SizedBox(height: AppSizes.padding);
  static const Widget verticalSpaceLarge = SizedBox(height: AppSizes.paddingLarge);

  static const Widget horizontalSpaceSmall = SizedBox(width: AppSizes.paddingSmall);
  static const Widget horizontalSpaceMedium = SizedBox(width: AppSizes.padding);
  static const Widget horizontalSpaceLarge = SizedBox(width: AppSizes.paddingLarge);

  static EdgeInsets get screenPadding => const EdgeInsets.symmetric(
    horizontal: AppSizes.padding,
    vertical: AppSizes.padding,
  );

  static EdgeInsets get screenPaddingHorizontal => const EdgeInsets.symmetric(
    horizontal: AppSizes.padding,
  );

  static EdgeInsets get screenPaddingVertical => const EdgeInsets.symmetric(
    vertical: AppSizes.padding,
  );

  static BorderRadius get defaultBorderRadius => BorderRadius.circular(AppSizes.borderRadius);
  static BorderRadius get largeBorderRadius => BorderRadius.circular(AppSizes.borderRadiusLarge);
  static BorderRadius get smallBorderRadius => BorderRadius.circular(AppSizes.borderRadiusSmall);

  static BoxShadow get defaultShadow => BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow get elevatedShadow => BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'shoes':
        return AppColors.shoesColor;
      case 'body':
        return AppColors.bodyColor;
      case 'jeans':
        return AppColors.jeansColor;
      case 'underwear':
        return AppColors.underwearColor;
      case 'bedding':
        return AppColors.beddingColor;
      case 'glasses':
        return AppColors.glassesColor;
      case 'bike':
        return AppColors.bikeColor;
      default:
        return AppColors.customColor;
    }
  }

  static Widget buildEmptyState({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? action,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textTertiary,
          ),
          verticalSpaceMedium,
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpaceSmall,
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            verticalSpaceLarge,
            action,
          ],
        ],
      ),
    );
  }

  static Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
    );
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
    );
  }
}