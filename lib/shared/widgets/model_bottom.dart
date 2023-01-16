import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class ModelBotton extends StatelessWidget {
  final VoidCallback onTap;
  final String svgPath;
  final String text;
  final Color color;
  final double? sizeW;
  final double? sizeH;

  const ModelBotton({
    Key? key,
    required this.onTap,
    required this.svgPath,
    required this.text,
    required this.color,
    this.sizeW,
    this.sizeH,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 17,
              ),
              child: SvgPicture.asset(
                svgPath,
                width: sizeW,
                height: sizeH,
              ),
            ),
          ),
          const SizedBox(width: 25),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.blackText,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
