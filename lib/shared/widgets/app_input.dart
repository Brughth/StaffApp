import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class AppInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? initialValue;
  final String? label;
  final bool readOnly;
  final bool enable;
  final AutovalidateMode autoValidate;
  final TextAlign textAlign;
  final Function(String value)? onChange;
  final List<String? Function(String?)> validators;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final bool? hideText;
  final Widget? suffixIcon;
  final Widget? prefix;
  final bool showEyes;
  final bool obscureText;
  final int minLines, maxLines;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final Color textColor;
  final Color? cursorColor;
  final Color errorColor;
  final VoidCallback? onTap;
  final bool required;

  const AppInput({
    super.key,
    required this.controller,
    this.hint,
    this.initialValue,
    this.label,
    this.readOnly = false,
    this.enable = true,
    this.autoValidate = AutovalidateMode.disabled,
    this.textAlign = TextAlign.start,
    this.onChange,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.hideText,
    this.suffixIcon,
    this.prefix,
    this.showEyes = false,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.focusNode,
    this.inputFormatters,
    this.prefixText,
    this.textColor = AppColors.textColor,
    this.cursorColor,
    this.errorColor = AppColors.errorColor,
    this.validators = const [],
    this.onTap,
    this.required = false,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool _isObscure = true;
  @override
  void initState() {
    setState(() {
      widget.hideText != null
          ? _isObscure = widget.hideText!
          : _isObscure = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideText != null) {
      _isObscure = widget.hideText!;
    }
    InputBorder enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.textColor.withOpacity(.5),
      ),
    );

    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.textColor.withOpacity(.5),
      ),
    );

    InputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.lightGreen,
      ),
    );

    InputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: widget.errorColor,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.label}",
                  style: const TextStyle(
                    color: AppColors.blackText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.required)
                  const Text(
                    "*",
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
              ],
            ),
          ),
        TextFormField(
          controller: widget.controller,
          onTap: widget.onTap,
          initialValue: widget.initialValue,
          enabled: widget.enable,
          validator: FormBuilderValidators.compose(widget.validators),
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          onChanged: widget.onChange,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          focusNode: widget.focusNode,
          autovalidateMode: widget.autoValidate,
          keyboardType: widget.keyboardType,
          cursorColor: widget.cursorColor,
          textAlign: widget.textAlign,
          obscureText: widget.obscureText ? _isObscure : false,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            suffixIcon: (widget.showEyes == true && widget.obscureText == true)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: _isObscure
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: const Icon(
                              Icons.visibility_outlined,
                              size: 25,
                              color: AppColors.textColor,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: const Icon(
                              Icons.visibility_off_outlined,
                              size: 25,
                              color: AppColors.textColor,
                            ),
                          ),
                  )
                : widget.suffixIcon,
            // contentPadding: const EdgeInsets.only(
            //   right: 10,
            //   top: 16,
            //   bottom: 16,
            //   left: 16,
            // ),
            prefixIcon: widget.prefix,
            focusedErrorBorder: errorBorder,
            errorBorder: errorBorder,
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            border: border,
          ),
        ),
      ],
    );
  }
}
