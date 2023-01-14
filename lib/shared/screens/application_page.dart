import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staff_app/shared/theming/app_colors.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController transitionAnimationController;
  @override
  void initState() {
    transitionAnimationController = BottomSheet.createAnimationController(this);
    transitionAnimationController.duration = const Duration(milliseconds: 500);
    transitionAnimationController.reverseDuration =
        const Duration(milliseconds: 500);
    transitionAnimationController.drive(CurveTween(curve: Curves.easeIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Liste des personnes",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/person.svg',
                    color: AppColors.lightGreen,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                      // scrollbars: false,
                      // overscroll: false,
                      ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return;
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (int i = 1; i <= 10; i++) ...[
                          Container(
                            height: 70,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 35,
                                          child: CircleAvatar(
                                            radius: 34,
                                            backgroundColor:
                                                AppColors.blackBlue,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                "Olice SONA",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "brughthsona@gmail.com",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.textColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "22 Ans",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
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
                                  onTap: () {
                                    showActionBottomSheet();
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider()
                        ],
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showActionBottomSheet() {
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
              InkWell(
                onTap: () {},
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGreen.withOpacity(.1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 17,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: AppColors.lightGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Modifier",
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 17,
                          ),
                        ),
                        Icon(
                          Icons.navigate_next,
                          size: 20,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
