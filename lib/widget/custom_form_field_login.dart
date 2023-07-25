import 'package:flutter/material.dart';

import '../theme.dart';

class CustomFormFieldLogin extends StatelessWidget {
  final String title;
  final String hint;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  const CustomFormFieldLogin(
      {Key? key,
      required this.title,
      required this.hint,
      this.validator,
      this.keyboardType,
      required this.controller,
      required this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: primaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            readOnly: readOnly,
            cursorColor: primaryTextColor,
            keyboardType: keyboardType,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              hintText: hint,
              // hintStyle: hintTextStyle.copyWith(
              //   fontSize: 12,
              //   fontWeight: regular,
              // ),
              // fillColor: backgorundFieldColor,
              // filled: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryTextColor),
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
