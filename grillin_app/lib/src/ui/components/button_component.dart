import 'package:flutter/material.dart';

import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';

// ignore: must_be_immutable
class ButtonComponent extends StatelessWidget {
  ButtonComponent({
    super.key,
    this.isEnabled = true,
    this.color = KColors.primary,
    this.label = KStrings.accept,
    this.onAccept,
    this.textStyle,
  });

  bool isEnabled = true;
  String label = KStrings.accept;
  Color color = KColors.primary;
  Function()? onAccept;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onAccept : () {},
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [KStyles().buttonShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: textStyle ??
                    const TextStyle(
                      color: KColors.white,
                      fontSize: KValues.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
          Visibility(
            visible: !isEnabled,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: KColors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [KStyles().buttonShadow],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: textStyle ??
                      const TextStyle(
                        color: KColors.white,
                        fontSize: KValues.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
