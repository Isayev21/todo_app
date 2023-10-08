import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget emptyContentView(
    {required BuildContext context,
    required SvgPicture image,
    required String content}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: image, 
      ),
      Text(
        content,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ],
  );
}
