import 'dart:io';
import 'dart:math';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staff_app/shared/theming/app_colors.dart';
import 'package:staff_app/shared/widgets/app_button.dart';
import 'package:staff_app/shared/widgets/custom_icon_button.dart';

class CropImageScreen extends StatefulWidget {
  final File image;
  const CropImageScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  late CustomImageCropController controller;
  bool isLoading = false;
  CustomCropShape cropShape = CustomCropShape.Circle;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/arrow_left.svg",
                  ),
                ),
                const Expanded(
                  child: Text(
                    "Recadrer l'image",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: CustomImageCrop(
              cropController: controller,
              image: FileImage(widget.image),
              cropPercentage: .7,
              shape: cropShape,
              overlayColor: AppColors.lightGreen.withOpacity(.2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.reset,
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () => controller.addTransition(
                  CropImageData(scale: 1.33),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () => controller.addTransition(
                  CropImageData(scale: 0.75),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () => controller.addTransition(
                  CropImageData(angle: -pi / 4),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () => controller.addTransition(
                  CropImageData(angle: pi / 4),
                ),
              ),
              IconButton(
                icon: cropShape == CustomCropShape.Circle
                    ? const Icon(Icons.square_outlined)
                    : const Icon(Icons.circle_outlined),
                onPressed: () {
                  if (cropShape == CustomCropShape.Circle) {
                    setState(() {
                      cropShape = CustomCropShape.Square;
                    });
                  } else {
                    setState(() {
                      cropShape = CustomCropShape.Circle;
                    });
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppButton(
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  var image = await controller.onCropImage();
                  if (image != null) {
                    print(image);
                    Navigator.of(context).pop(image);
                  }
                  setState(() {
                    isLoading = false;
                  });
                } catch (e) {
                  print(e);
                }
              },
              bgColor: AppColors.lightGreen,
              loading: isLoading,
              loadingColor: AppColors.white,
              child: const Text(
                "Sauvegarder",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
