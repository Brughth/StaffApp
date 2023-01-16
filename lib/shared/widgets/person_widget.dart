import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:staff_app/person/data/models/person_model.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class PersonWidget extends StatelessWidget {
  final PersonModel person;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final VoidCallback onImageTap;
  const PersonWidget({
    super.key,
    required this.person,
    required this.onTap,
    required this.onMoreTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      child: Row(
        children: [
          Hero(
            tag: person.id,
            child: CircleAvatar(
              radius: 35,
              child: GestureDetector(
                onTap: onImageTap,
                child: CircleAvatar(
                  radius: 34,
                  backgroundImage: CachedNetworkImageProvider(person.image),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: onTap,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${person.lastName ?? ''} ${person.firstName}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          person.email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          person.phone,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: onMoreTap,
            child: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
    );
  }
}
