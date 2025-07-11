class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validateMeasurementTitle(String? value) {
    return validateRequired(value, 'Measurement title');
  }

  static String? validateBrandName(String? value) {
    return validateRequired(value, 'Brand name');
  }

  static String? validateSize(String? value) {
    return validateRequired(value, 'Size');
  }

  static String? validateTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tag cannot be empty';
    }

    if (value.trim().length < 2) {
      return 'Tag must be at least 2 characters';
    }

    return null;
  }
}