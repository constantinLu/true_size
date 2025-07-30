import 'package:flutter/material.dart';

import '../../../core/utils/validation.dart';
import '../palette.dart' show whiteCultured;

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.validationMessage,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? validationMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: whiteCultured,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: Validation.validateField,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: whiteCultured),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            errorText: validationMessage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  validationMessage != null && validationMessage!.isNotEmpty
                      ? const BorderSide(color: Colors.red, width: 1)
                      : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    validationMessage != null && validationMessage!.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF8B5CF6),
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
