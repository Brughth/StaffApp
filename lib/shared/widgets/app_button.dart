import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class AppButton extends StatelessWidget {
  Widget child;
  VoidCallback? onPressed;
  Color? bgColor;
  Color? borderColor;
  bool enable;
  bool haveTop;
  bool loading;
  Color? loadingColor;

  AppButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.enable = true,
    this.bgColor,
    this.borderColor,
    this.loading = false,
    this.haveTop = true,
    this.loadingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: enable ? bgColor : bgColor?.withOpacity(.6),
            border: borderColor != null
                ? Border.all(
                    color: borderColor!,
                    width: 1.5,
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  (!loading && enable && onPressed != null) ? onPressed : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Opacity(opacity: loading ? 0 : 1, child: child),
              ),
            ),
          ),
        ),
        loading == false
            ? Container()
            : Positioned.fill(
                child: Center(
                  child: CupertinoTheme(
                    data: CupertinoTheme.of(context).copyWith(
                      brightness: bgColor == AppColors.lightGreen
                          ? Brightness.dark
                          : Brightness.light,
                    ),
                    child: CupertinoActivityIndicator(
                      radius: 16,
                      color: loadingColor,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
