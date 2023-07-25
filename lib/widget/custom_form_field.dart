import 'package:flutter/material.dart';

import '../theme.dart';

class CustomFormField extends StatelessWidget {
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String title;
  final TextEditingController controller;
  final bool isReadOnly;
  const CustomFormField({
    Key? key,
    required this.hint,
    required this.title,
    this.validator,
    this.keyboardType,
    this.isReadOnly = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textFieldStyle = isReadOnly
        ? secondaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: regular,
            color: Colors.grey, // Set text color to grey when readonly
          )
        : secondaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            cursorColor: primaryTextColor,
            keyboardType: keyboardType,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            readOnly: isReadOnly,
            style: textFieldStyle,
            decoration: InputDecoration(
              labelText: title,
              labelStyle: secondaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
              suffixStyle: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
              errorStyle: const TextStyle(height: 0),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              hintText: hint,
              hintStyle: secondaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
              fillColor: whiteColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryTextColor),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
