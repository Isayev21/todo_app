import 'package:flutter/material.dart';

Widget iconButton({
    required Function() onPressed,
    required Icon icon,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }


