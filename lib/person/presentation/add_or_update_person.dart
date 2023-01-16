import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:staff_app/person/data/models/person_model.dart';
import 'package:staff_app/person/data/repositories/person_repository.dart';
import 'package:staff_app/person/presentation/crop_image_screen.dart';
import 'package:staff_app/shared/theming/app_colors.dart';
import 'package:staff_app/shared/utils/app_routes.dart';
import 'package:staff_app/shared/widgets/app_button.dart';
import 'package:staff_app/shared/widgets/app_input.dart';
import 'package:staff_app/shared/widgets/app_snackbar.dart';
import 'package:staff_app/shared/widgets/custom_icon_button.dart';
import 'package:staff_app/shared/widgets/model_bottom.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class AddOrUpdatePersonScreen extends StatefulWidget {
  final PersonModel? person;
  const AddOrUpdatePersonScreen({
    super.key,
    this.person,
  });

  @override
  State<AddOrUpdatePersonScreen> createState() =>
      _AddOrUpdatePersonScreenState();
}

class _AddOrUpdatePersonScreenState extends State<AddOrUpdatePersonScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _subnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late PersonRepository _personRepository;
  late AnimationController transitionAnimationController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _dateOfBirthCotroller;
  MemoryImage? _image;
  late DateTime? __dateOfBirth;
  bool isLoading = false;

  DateTime selectedDate = DateTime(2015);

  late String? _remoteImage;

  @override
  void initState() {
    _personRepository = PersonRepository();
    _nameController = TextEditingController(text: widget.person?.firstName);
    _subnameController = TextEditingController(text: widget.person?.lastName);
    _emailController = TextEditingController(text: widget.person?.email);
    _phoneController = TextEditingController(text: widget.person?.phone);
    _dateOfBirthCotroller = TextEditingController(
      text: widget.person != null
          ? DateFormat.yMd().format(widget.person!.dateOfBirth)
          : null,
    );

    __dateOfBirth = widget.person?.dateOfBirth;
    _remoteImage = widget.person?.image;

    transitionAnimationController = BottomSheet.createAnimationController(this);
    transitionAnimationController.duration = const Duration(milliseconds: 500);
    transitionAnimationController.reverseDuration =
        const Duration(milliseconds: 500);
    transitionAnimationController.drive(CurveTween(curve: Curves.easeIn));
    super.initState();
  }

  Future<MemoryImage?> getImage(ImageSource source) async {
    setState(() {
      _image = null;
    });
    final ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: source);
    if (image != null) {
      print(image);
      var fileSize = (File(image.path).lengthSync() / (1024 * 1024));
      if (fileSize > 4) {
        AppSnackBar.showError(
          message:
              "Assurez-vous de choisir une image inférieure ou égale à 4 Mo",
          context: context,
        );
        return null;
      }

      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropImageScreen(
            image: File(image.path),
          ),
        ),
      );

      if (result != null) {
        return result;
      } else {
        return MemoryImage(File(image.path).readAsBytesSync());
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthCotroller.dispose();
    transitionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 10),
                Row(
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
                        widget.person != null
                            ? "Modifier ${widget.person?.firstName}"
                            : "Ajouter une personne",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                FadeInDown(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.transparent,
                      ),
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: AppColors.lightBlue,
                        child: _image != null
                            ? CircleAvatar(
                                backgroundColor:
                                    AppColors.lightGreen.withOpacity(.8),
                                backgroundImage: MemoryImage(_image!.bytes),
                                radius: 78,
                              )
                            : _remoteImage != null
                                ? CircleAvatar(
                                    backgroundColor:
                                        AppColors.lightGreen.withOpacity(.8),
                                    backgroundImage: CachedNetworkImageProvider(
                                      _remoteImage!,
                                    ),
                                    radius: 78,
                                  )
                                : CircleAvatar(
                                    backgroundColor:
                                        AppColors.lightGreen.withOpacity(.8),
                                    radius: 78,
                                  ),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 0,
                        child: CustomIconButton(
                          onTap: () {
                            _showPicProfilImageBottonSheet();
                          },
                          bgColor: AppColors.white,
                          bordeWidth: 1.8,
                          child: SvgPicture.asset(
                            "assets/icons/image_add.svg",
                            color: AppColors.lightBlue,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        controller: _nameController,
                        required: true,
                        label: 'Nom',
                        hint: "Nom",
                        keyboardType: TextInputType.name,
                        prefix: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/person.svg',
                            color: AppColors.textColor,
                          ),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                            errorText: "Le nom est obligatoire",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppInput(
                        controller: _subnameController,
                        label: 'prénom',
                        hint: "prénom",
                        keyboardType: TextInputType.name,
                        prefix: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/person.svg',
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppInput(
                  controller: _emailController,
                  label: 'E-mail',
                  required: true,
                  hint: "emailexample@gmail.com",
                  keyboardType: TextInputType.emailAddress,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/vector.svg',
                      color: AppColors.textColor,
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(
                      errorText: "L'address e-mail est obligatoire",
                    ),
                    FormBuilderValidators.email(
                      errorText: "veuillez entrer un e-mail valide",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppInput(
                  controller: _phoneController,
                  label: 'Téléphone',
                  hint: "692*******",
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.phone,
                  required: true,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/phone.svg',
                      color: AppColors.textColor,
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(
                      errorText: "Le numéro est obligatoire",
                    ),
                    FormBuilderValidators.match(
                      RegExp(r"^(\+?237)?(22212331242|243|6[5-9][0-9])[0-9]{6}$")
                          .pattern,
                      errorText: "veuillez entrer un numéro valide",
                    )
                  ],
                ),
                const SizedBox(height: 25),
                FadeIn(
                  child: AppInput(
                    onTap: () {
                      //showDateRangePickerDialog();
                      showDatePickerDialog();
                    },
                    required: true,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "veuillez selectionner Date de naissance",
                      )
                    ],
                    hint: "Sélectionner",
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    label: "Date de naissance",
                    controller: _dateOfBirthCotroller,
                    prefix: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/board.svg',
                        color: AppColors.textColor,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                AppButton(
                  loading: isLoading,
                  loadingColor: AppColors.white,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.person != null) {
                        _handleUpdatePerson();
                      } else {
                        _handleAddPerson();
                      }
                    }
                  },
                  bgColor: AppColors.lightGreen,
                  child: Text(
                    widget.person != null ? "Modifier" : "Ajouter",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleUpdatePerson() async {
    try {
      setState(() {
        isLoading = true;
      });

      String imageUrl;
      if (_image != null) {
        imageUrl = await _personRepository.uploadFileToFireStorage(_image!);
      } else {
        imageUrl = widget.person!.image;
      }

      var data = {
        "firstName": _nameController.text,
        "lastName": _subnameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "dateOfBirth": selectedDate.toUtc().toIso8601String(),
        "image": imageUrl,
      };

      var result = await _personRepository.updatePerson(
        id: widget.person!.id,
        data: data,
      );

      setState(() {
        isLoading = false;
        _nameController.text = '';
        _subnameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
        _dateOfBirthCotroller.text = '';
        _image = null;
        _remoteImage = null;
      });

      Navigator.of(context).pop();

      AppSnackBar.showSuccess(
        message: "Modification réussi",
        context: context,
      );
    } on FirebaseException catch (ex) {
      print(ex);
      setState(() {
        isLoading = false;
      });

      AppSnackBar.showError(
        message: "${ex.message ?? ex.code} ",
        context: context,
      );
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      AppSnackBar.showError(
        message: e.toString(),
        context: context,
      );
    }
  }

  _handleAddPerson() async {
    if (_image == null) {
      AppSnackBar.showError(
        message: "veuillez ajouter une image",
        context: context,
      );
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        var imageUrl = await _personRepository.uploadFileToFireStorage(_image!);

        var data = {
          "firstName": _nameController.text,
          "lastName": _subnameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
          "dateOfBirth": selectedDate.toUtc().toIso8601String(),
          "image": imageUrl,
        };

        var result = await _personRepository.addPerson(data: data);

        setState(() {
          isLoading = false;
          _nameController.text = '';
          _subnameController.text = '';
          _emailController.text = '';
          _phoneController.text = '';
          _dateOfBirthCotroller.text = '';
          _image = null;
        });

        AppSnackBar.showSuccess(
          message: "ajout réussi",
          context: context,
        );
      } on FirebaseException catch (ex) {
        print(ex);
        setState(() {
          isLoading = false;
        });

        AppSnackBar.showError(
          message: "${ex.message ?? ex.code} ",
          context: context,
        );
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        AppSnackBar.showError(
          message: e.toString(),
          context: context,
        );
      }
    }
  }

  showDatePickerDialog() {
    return showGeneralDialog(
      barrierLabel: "Date",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 350,
            width: 320,
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
                  Expanded(
                    child: ScrollDatePicker(
                      selectedDate: selectedDate,
                      onDateTimeChanged: (value) {
                        setState(() {
                          selectedDate = value;
                          _dateOfBirthCotroller.text =
                              DateFormat.yMd().format(selectedDate);
                        });
                      },
                      maximumDate: DateTime.now(),
                    ),
                  ),
                  AppButton(
                    bgColor: AppColors.lightGreen,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
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

  // showDateRangePickerDialog() {
  //   showGeneralDialog(
  //     barrierLabel: "Date",
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: const Duration(milliseconds: 500),
  //     context: context,
  //     pageBuilder: (context, anim1, anim2) {
  //       return Align(
  //         alignment: Alignment.center,
  //         child: Container(
  //           height: 350,
  //           width: 320,
  //           padding: const EdgeInsets.symmetric(
  //             vertical: 20,
  //             horizontal: 20,
  //           ),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Material(
  //             color: AppColors.white,
  //             child: SfDateRangePicker(
  //               maxDate: DateTime.now(),
  //               selectionMode: DateRangePickerSelectionMode.single,
  //               showActionButtons: true,
  //               cancelText: "Annuler",
  //               onSubmit: (value) {
  //                 setState(
  //                   () {
  //                     if (value is DateTime) {
  //                       __dateOfBirth = value;
  //                       _dateOfBirthCotroller.text =
  //                           DateFormat.yMd().format(__dateOfBirth!);
  //                       Navigator.pop(context);
  //                     } else {
  //                       AppSnackBar.showError(
  //                         message:
  //                             "Veuillez sélectionner votre dates de naissance",
  //                         context: context,
  //                       );
  //                     }
  //                   },
  //                 );
  //               },
  //               onCancel: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, anim1, anim2, child) {
  //       return SlideTransition(
  //         position: Tween(
  //           begin: const Offset(0, 1),
  //           end: const Offset(0, 0),
  //         ).animate(anim1),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  _showPicProfilImageBottonSheet() async {
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
                svgPath: "assets/icons/galery.svg",
                text: "Ouvrir ma galerie",
                onTap: () async {
                  Navigator.pop(context);
                  var image = await getImage(ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _image = image;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ModelBotton(
                color: const Color(0xFF0F00C0),
                svgPath: "assets/icons/camera.svg",
                text: "Prendre une photo",
                onTap: () async {
                  Navigator.pop(context);
                  var image = await getImage(ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _image = image;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
