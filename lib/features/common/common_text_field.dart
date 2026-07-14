import 'package:flutter/material.dart';
import 'package:task_manager/constants/theme/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;
  final Function(String)? onValueChanged;
  CommonTextField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.validator,
    required this.maxLines,
    this.onValueChanged,
  });

  final customBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: AppColors.grey, width: 2),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 12,
        //     fontWeight: FontWeight.w700,
        //     color: AppColors.white,
        //   ),
        // ),
        // SizedBox(height: 8),
        TextFormField(
          cursorColor: AppColors.violet,
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          onChanged: onValueChanged,
          decoration: InputDecoration(
            fillColor: Color(0xFF161823),
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
            border: customBorder,
            enabledBorder: customBorder,
            focusedBorder: customBorder,
            errorBorder: customBorder,
          ),
        ),
      ],
    );
  }
}
