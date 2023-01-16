import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staff_app/person/data/models/person_model.dart';
import 'package:staff_app/shared/widgets/custom_icon_button.dart';

class ImageScreen extends StatelessWidget {
  final PersonModel person;
  const ImageScreen({
    super.key,
    required this.person,
  });

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
                Expanded(
                  child: Text(
                    "${person.lastName ?? ''} ${person.firstName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 1,
              maxScale: 5,
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ClipRRect(
                        child: Hero(
                          tag: person.id,
                          child: CachedNetworkImage(
                            imageUrl: person.image,
                          ),
                        ),
                      ),
                    ],
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
