class FormValidator {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? groupName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Group name is required';
    }
    if (value.trim().length < 2) {
      return 'Group name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Group name must be less than 50 characters';
    }
    return null;
  }

  static String? groupDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 5) {
      return 'Description must be at least 5 characters';
    }
    if (value.trim().length > 200) {
      return 'Description must be less than 200 characters';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? Function(String? value) minLength(int min) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'This field is required';
      }
      if (value.trim().length < min) {
        return 'Must be at least $min characters';
      }
      return null;
    };
  }

  static String? Function(String? value) maxLength(int max) {
    return (String? value) {
      if (value != null && value.trim().length > max) {
        return 'Must be less than $max characters';
      }
      return null;
    };
  }
}
