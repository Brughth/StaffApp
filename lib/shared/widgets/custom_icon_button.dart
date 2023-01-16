import 'package:flutter/material.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? bgColor;
  final double bordeWidth;
  const CustomIconButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.bordeWidth = 1.0,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.bordeColor,
            width: bordeWidth,
          ),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
