import 'package:flutter/material.dart';

Widget getTextFormField({
    required String hintText,
    required TextEditingController controller,
    int? maxLines,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }