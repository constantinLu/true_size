// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:true_size/core/utils/form_validator.dart';

const bool _autoTextFieldValidation = false;

const String GroupNameValueKey = 'groupName';
const String GroupDescriptionValueKey = 'groupDescription';

final Map<String, TextEditingController>
    _AddGroupFormViewTextEditingControllers = {};

final Map<String, FocusNode> _AddGroupFormViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddGroupFormViewTextValidations =
    {
  GroupNameValueKey: FormValidator.required,
  GroupDescriptionValueKey: FormValidator.required,
};

mixin $AddGroupFormView {
  TextEditingController get groupNameController =>
      _getFormTextEditingController(GroupNameValueKey);
  TextEditingController get groupDescriptionController =>
      _getFormTextEditingController(GroupDescriptionValueKey);

  FocusNode get groupNameFocusNode => _getFormFocusNode(GroupNameValueKey);
  FocusNode get groupDescriptionFocusNode =>
      _getFormFocusNode(GroupDescriptionValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddGroupFormViewTextEditingControllers.containsKey(key)) {
      return _AddGroupFormViewTextEditingControllers[key]!;
    }

    _AddGroupFormViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddGroupFormViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddGroupFormViewFocusNodes.containsKey(key)) {
      return _AddGroupFormViewFocusNodes[key]!;
    }
    _AddGroupFormViewFocusNodes[key] = FocusNode();
    return _AddGroupFormViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    groupNameController.addListener(() => _updateFormData(model));
    groupDescriptionController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    groupNameController.addListener(() => _updateFormData(model));
    groupDescriptionController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          GroupNameValueKey: groupNameController.text,
          GroupDescriptionValueKey: groupDescriptionController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _AddGroupFormViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddGroupFormViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddGroupFormViewTextEditingControllers.clear();
    _AddGroupFormViewFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get groupNameValue => this.formValueMap[GroupNameValueKey] as String?;
  String? get groupDescriptionValue =>
      this.formValueMap[GroupDescriptionValueKey] as String?;

  set groupNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({GroupNameValueKey: value}),
    );

    if (_AddGroupFormViewTextEditingControllers.containsKey(
        GroupNameValueKey)) {
      _AddGroupFormViewTextEditingControllers[GroupNameValueKey]?.text =
          value ?? '';
    }
  }

  set groupDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({GroupDescriptionValueKey: value}),
    );

    if (_AddGroupFormViewTextEditingControllers.containsKey(
        GroupDescriptionValueKey)) {
      _AddGroupFormViewTextEditingControllers[GroupDescriptionValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasGroupName =>
      this.formValueMap.containsKey(GroupNameValueKey) &&
      (groupNameValue?.isNotEmpty ?? false);
  bool get hasGroupDescription =>
      this.formValueMap.containsKey(GroupDescriptionValueKey) &&
      (groupDescriptionValue?.isNotEmpty ?? false);

  bool get hasGroupNameValidationMessage =>
      this.fieldsValidationMessages[GroupNameValueKey]?.isNotEmpty ?? false;
  bool get hasGroupDescriptionValidationMessage =>
      this.fieldsValidationMessages[GroupDescriptionValueKey]?.isNotEmpty ??
      false;

  String? get groupNameValidationMessage =>
      this.fieldsValidationMessages[GroupNameValueKey];
  String? get groupDescriptionValidationMessage =>
      this.fieldsValidationMessages[GroupDescriptionValueKey];
}

extension Methods on FormStateHelper {
  setGroupNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GroupNameValueKey] = validationMessage;
  setGroupDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GroupDescriptionValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    groupNameValue = '';
    groupDescriptionValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      GroupNameValueKey: getValidationMessage(GroupNameValueKey),
      GroupDescriptionValueKey: getValidationMessage(GroupDescriptionValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddGroupFormViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddGroupFormViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      GroupNameValueKey: getValidationMessage(GroupNameValueKey),
      GroupDescriptionValueKey: getValidationMessage(GroupDescriptionValueKey),
    });
