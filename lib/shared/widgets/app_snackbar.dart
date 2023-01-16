import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class AppSnackBar {
  static Flushbar? _flushbar;

  static Future showError({
    required String message,
    required BuildContext context,
  }) async {
    if (_flushbar != null && _flushbar!.isShowing()) {
      await _flushbar!.dismiss();
    }
    _flushbar = Flushbar(
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    );
    return _flushbar!.show(context);
  }

  static Future showSuccess({
    required String message,
    required BuildContext context,
    Function(Flushbar<dynamic>)? onTap,
    duration = const Duration(seconds: 3),
    VoidCallback? onClose,
  }) async {
    if (_flushbar != null && _flushbar!.isShowing()) {
      await _flushbar!.dismiss();
    }
    _flushbar = Flushbar(
      onTap: onTap,
      messageText: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: onClose,
            child: SvgPicture.asset(
              "assets/icons/close.svg",
              height: 25,
              width: 25,
            ),
          )
        ],
      ),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Image.asset("assets/icons/smill.png"),
      backgroundColor: AppColors.black,
      duration: duration,
    );
    return _flushbar!.show(context);
  }
}
