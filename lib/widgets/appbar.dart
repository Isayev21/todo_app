import 'package:flutter/material.dart';

PreferredSizeWidget appBar(Widget title, List<Widget>? actions) {
  return AppBar(
    centerTitle: true,
    title: title,
    actions: actions,
  );
}
