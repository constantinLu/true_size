import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../../../core/utils/form_validator.dart';
import '../../common/palette.dart';
import '../../common/widgets/text_field_widget.dart';
import 'add_group_form_view.form.dart';
import 'add_group_form_viewmodel.dart';
import 'widget/color_picker_widget.dart';
import 'widget/display_icon_widget.dart';

@FormView(
  fields: [
    FormTextField(name: 'groupName', validator: FormValidator.required),
    FormTextField(name: 'groupDescription', validator: FormValidator.required),
  ],
  autoTextFieldValidation: false,
)
class AddGroupFormView extends StackedView<AddGroupFormViewModel> with $AddGroupFormView {
  const AddGroupFormView({super.key});

  @override
  Widget builder(BuildContext context, AddGroupFormViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: whiteCultured),
          onPressed: viewModel.closeForm,
        ),
        title: const Text(
          'New Group',
          style: TextStyle(color: whiteCultured, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selected Icon Display
                    DisplayIconWidget(context: context, viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Name Field
                    TextFieldWidget(
                      label: 'Name',
                      controller: groupNameController,
                      focusNode: groupNameFocusNode,
                      validationMessage: viewModel.groupNameValidationMessage,
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    TextFieldWidget(
                      label: 'Description',
                      controller: groupDescriptionController,
                      focusNode: groupDescriptionFocusNode,
                      validationMessage: viewModel.groupDescriptionValidationMessage,
                    ),
                    const SizedBox(height: 24),

                    // Color Picker
                    ColorPickerWidget(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // // Measurements text
                    // const Text(
                    //   'Measurements',
                    //   style: TextStyle(
                    //     color: whiteCultured,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    //
                    // // Add Measurement Button
                    // ButtonWidget(viewModel: viewModel),
                    // const SizedBox(height: 16),
                    //
                    // // Measurements List - returns a list
                    // ...viewModel.measurements.asMap().entries.map((entry) {
                    //   final index = entry.key;
                    //   final measurement = entry.value;
                    //   return MeasurementItemWidget(viewModel: viewModel, measurement: measurement, index: index);
                    // }),
                    //
                    // const SizedBox(height: 16),
                    //
                    // // Tags Section
                    // TagSelectionWidget(viewModel: viewModel),
                  ],
                ),
              ),
            ),

            // Save Button
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: viewModel.saveGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    disabledBackgroundColor: Palette.disabledBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    viewModel.isBusy ? 'Saving...' : 'Save',
                    style: const TextStyle(
                      color: whiteCultured,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AddGroupFormViewModel viewModelBuilder(BuildContext context) => AddGroupFormViewModel();

  @override
  void onViewModelReady(AddGroupFormViewModel viewModel) {
    viewModel.initializeForm();
    syncFormWithViewModel(viewModel);
  }

// @override
// void onDispose(AddGroupFormViewModel viewModel) {
//   super.onDispose(viewModel);
//   disposeForm();
// }
}
