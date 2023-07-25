import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  final String hint;
  final String icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.validator,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: primaryTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            cursorColor: primaryTextColor,
            keyboardType: keyboardType,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
              hintText: hint,
              hintStyle: primaryTextStyle.copyWith(
                fontSize: 12,
                color: const Color(0xFF728196),
                fontWeight: regular,
              ),
              fillColor: greyColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: primaryColor,
                ),
              ),
              prefixIcon: SvgPicture.asset(
                icon,
                width: 10,
                height: 10,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
