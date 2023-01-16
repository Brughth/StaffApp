import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:staff_app/person/data/models/person_model.dart';
import 'package:staff_app/shared/screens/image_screen.dart';
import 'package:staff_app/shared/theming/app_colors.dart';
import 'package:staff_app/shared/utils/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilScreen extends StatefulWidget {
  final PersonModel person;
  const ProfilScreen({
    Key? key,
    required this.person,
  }) : super(key: key);
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Hero(
              tag: widget.person.id,
              child: CircleAvatar(
                radius: 90,
                child: GestureDetector(
                  onTap: () {
                    navigateTo(context, ImageScreen(person: widget.person));
                  },
                  child: CircleAvatar(
                    radius: 89,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.person.image,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.person.lastName ?? ''} ${widget.person.firstName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text(
              "Email",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.black,
              ),
            ),
            subtitle: Text(
              widget.person.email,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            onTap: () {
              _openEmailApp(widget.person.email);
            },
          ),
          ListTile(
            title: const Text(
              "Phone",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.black,
              ),
            ),
            subtitle: Text(
              widget.person.phone,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
            onTap: () {
              _makePhoneCall(widget.person.phone);
            },
          ),
          ListTile(
            title: const Text(
              "Date de naissance",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.black,
              ),
            ),
            subtitle: Text(
              DateFormat.yMd().format(widget.person.dateOfBirth),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  _openEmailApp(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }
}
