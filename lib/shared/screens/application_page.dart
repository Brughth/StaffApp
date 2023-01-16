import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staff_app/person/data/models/person_model.dart';
import 'package:staff_app/person/data/repositories/person_repository.dart';
import 'package:staff_app/person/presentation/add_or_update_person.dart';
import 'package:staff_app/person/presentation/profile_screen.dart';
import 'package:staff_app/shared/screens/image_screen.dart';
import 'package:staff_app/shared/theming/app_colors.dart';
import 'package:staff_app/shared/utils/app_routes.dart';
import 'package:staff_app/shared/utils/const.dart';
import 'package:staff_app/shared/widgets/app_button.dart';
import 'package:staff_app/shared/widgets/model_bottom.dart';
import 'package:staff_app/shared/widgets/person_widget.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController transitionAnimationController;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _peopleCollection;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late PersonRepository _personRepository;
  @override
  void initState() {
    transitionAnimationController = BottomSheet.createAnimationController(this);
    transitionAnimationController.duration = const Duration(milliseconds: 500);
    transitionAnimationController.reverseDuration =
        const Duration(milliseconds: 500);
    transitionAnimationController.drive(CurveTween(curve: Curves.easeIn));
    _peopleCollection = _firestore.collection(peopleCollection).snapshots();
    _personRepository = PersonRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateTo(context, const AddOrUpdatePersonScreen());
        },
        icon: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
        label: const Text(
          "Ajouter",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Liste des personnes",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            overscroll: false,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              return;
            },
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _peopleCollection,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        radius: 16,
                        color: AppColors.lightGreen,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Une erreur inconnue s'est produite"),
                    );
                  }

                  if (snapshot.hasData) {
                    var docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text("Vide"),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var item = docs[index].data();
                        item['id'] = docs[index].id;

                        PersonModel person = PersonModel.fromJson(item);
                        return PersonWidget(
                          person: person,
                          onTap: () {
                            navigateTo(context, ProfilScreen(person: person));
                          },
                          onMoreTap: () {
                            showActionBottomSheet(person);
                          },
                          onImageTap: () {
                            navigateTo(context, ImageScreen(person: person));
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    );
                  }
                  return Container();
                }),
          ),
        ),
      ),
    );
  }

  showActionBottomSheet(PersonModel person) {
    showModalBottomSheet(
      context: context,
      transitionAnimationController: transitionAnimationController,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 30,
                ),
                child: Container(
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              ModelBotton(
                color: const Color(0xFF02C508),
                svgPath: "assets/icons/pen_edite.svg",
                text: "Modifier",
                onTap: () async {
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    AddOrUpdatePersonScreen(
                      person: person,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ModelBotton(
                color: AppColors.red,
                svgPath: "assets/icons/delete.svg",
                sizeW: 16,
                sizeH: 16,
                text: "Supprimer",
                onTap: () async {
                  Navigator.pop(context);
                  showDeletePersoneDialgue(person);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  showDeletePersoneDialgue(PersonModel person) {
    showGeneralDialog(
      barrierLabel: "Supprimer",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: AppColors.white,
              child: Column(
                children: [
                  Text(
                    "Supprimer ${person.firstName} !!!",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Text.rich(
                    TextSpan(
                      text: "Voulez‑vous vraiment supprimer ? ",
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                  AppButton(
                    onPressed: () async {
                      await _personRepository.deletePerson(person.id);
                      Navigator.pop(context);
                    },
                    bgColor: const Color.fromRGBO(35, 204, 183, 1),
                    child: const Text(
                      "Oui",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    borderColor: AppColors.bordeColor,
                    child: const Text(
                      "Non",
                      style: TextStyle(
                        color: AppColors.blackBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    );
  }
}
