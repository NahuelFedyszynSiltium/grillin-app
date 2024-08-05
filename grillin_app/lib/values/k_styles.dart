import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_values.dart';

class KStyles {
  //TEXT STYLES
  static const TextStyle homeCardBodyTextStyle = TextStyle(
    fontSize: KValues.fontSizeLargeXXL,
    color: KColors.white,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle homeCardTitleTextStyle = TextStyle(
    fontSize: KValues.fontSizeMedium,
    color: KColors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle homeCardSubTextStyle = TextStyle(
    fontSize: KValues.fontSizeSmall,
    color: KColors.white,
    fontWeight: FontWeight.w400,
  );

  BoxShadow buttonShadow = BoxShadow(
    color: KColors.black.withOpacity(0.05),
    offset: const Offset(0, 2),
    spreadRadius: 2,
    blurRadius: 5,
  );

  BoxShadow overlayShadow = BoxShadow(
    color: KColors.black.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 20,
  );
}
