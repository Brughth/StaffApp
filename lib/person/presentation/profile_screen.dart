import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:staff_app/person/data/models/person_model.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

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
            child: CircleAvatar(
              radius: 90,
              child: Hero(
                tag: widget.person.id,
                child: CircleAvatar(
                  radius: 89,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.person.image,
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
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.value,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String value;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 4),
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
