import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temple/models/contact_us_model.dart';
import 'package:temple/utils/secret.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/constant.dart';
import 'package:temple/utils/dimensions.dart';
import 'package:temple/widget/big_text.dart';
import 'package:temple/widget/show_custom_snakbar.dart';
import 'package:temple/widget/small_text.dart';
import 'package:http/http.dart' as http;

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  var fullNameController = TextEditingController();
  var messageController = TextEditingController();
  var emailAddressController = TextEditingController();
  var phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    TextEditingController().dispose();
    TextEditingController().dispose();
    TextEditingController().dispose();
    TextEditingController().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    final LatLng _initialPostion = const LatLng(22.381875, 69.84974);
    Future sendMail() async {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: json.encode(
          {
            'service_id': SECRET.CONTACT_US_SERVICE_ID,
            'template_id': SECRET.CONTACT_US_TEMPLATE_ID,
            'user_id': SECRET.CONTACT_US_USER_ID,
            'template_params': {
              'full_name': fullNameController.text,
              'message': messageController.text,
              'email_address': emailAddressController.text,
              'phone_number': phoneNumberController.text,
            }
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
      return response;
    }

    Future<void> addContactUs() {
      ContactUsModel form = ContactUsModel(
        fullName: fullNameController.text,
        phoneNumber: int.parse(phoneNumberController.text),
        emailAddress: emailAddressController.text,
        message: messageController.text,
        submitedAt: DateTime.now(),
      );
      return FirebaseFirestore.instance
          .collection('contact us')
          .add(form.toJson())
          .then((_) async {
        print("got data");
        final response = await sendMail();
        print(response.toString() + "sadjfaksjdhf");
        Get.snackbar(
            // borderColor: AppColors.mainColor,
            "All went well",
            "We got your information");
      }).catchError((error) {
        showCustomSnakBar("An error occured", title: "Attentation");
      });
    }

    return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: Constant.appBar("Contact US"),
        body: !_isLoading
            ? Form(
                key: _formKey,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 5, right: 5, top: 5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 2,
                            color: AppColors.mainColor,
                          ),
                        ),
                        height: Dimensions.pageViewContainer,
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: _initialPostion, zoom: 15),
                          zoomControlsEnabled: true,
                          compassEnabled: true,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: true,
                          myLocationEnabled: true,
                        ),
                      ),
                      SizedBox(height: Dimensions.height15),
                      Container(
                        // color: AppColors.secondryColor,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: "Contact Us",
                              size: Dimensions.font26,
                            ),
                            SizedBox(height: Dimensions.height20),
                            buildUsername(),
                            SizedBox(height: Dimensions.height15),
                            buildPhone(),
                            SizedBox(height: Dimensions.height15),
                            buildEmail(),
                            SizedBox(height: Dimensions.height15),
                            buildMessage(),
                            SizedBox(height: Dimensions.height15),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.height20,
                                          horizontal: Dimensions.width20),
                                      backgroundColor: AppColors.mainColor,
                                    ),
                                    onPressed: () async {
                                      if (ConnectivityResult.none !=
                                          await Connectivity()
                                              .checkConnectivity()) {
                                        final isValid =
                                            _formKey.currentState!.validate();
                                        FocusScope.of(context).unfocus();
                                        if (isValid) {
                                          _formKey.currentState!.save();
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await addContactUs();
                                          fullNameController.clear();
                                          messageController.clear();
                                          emailAddressController.clear();
                                          phoneNumberController.clear();

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      } else {
                                        showCustomSnakBar(
                                            "Please Turn on Your Internet",
                                            title: "Attention");
                                      }
                                    },
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          fontSize: Dimensions.font20,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ), //contact us container
                      SizedBox(height: Dimensions.height20),
                      Container(
                        height: Dimensions.height30 * 11,
                        width: double.infinity,
                        padding: EdgeInsets.all(Dimensions.width20),
                        color: AppColors.secondryDarkColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: "Let's get In Touch",
                              color: Colors.white,
                              size: Dimensions.iconSize24,
                            ),
                            SizedBox(height: Dimensions.height20),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SmallText(
                                text:
                                    "SH 6, GSFC Township, Motikhavdi, Gujarat 361140",
                                size: Dimensions.font20,
                                color: AppColors.iconColor1,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SmallText(
                                text: "gsfctownship@gmail.com",
                                size: Dimensions.font20,
                                color: AppColors.iconColor1,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SmallText(
                                text: "+91 9727326326",
                                size: Dimensions.font20,
                                color: AppColors.iconColor1,
                              ),
                            ),
                            SizedBox(height: Dimensions.height20),
                            BigText(
                              text: "Connect With Us",
                              color: Colors.white,
                              size: Dimensions.iconSize24,
                            ),
                            SizedBox(height: Dimensions.height15),
                            Row(
                              children: [
                                SizedBox(
                                  height: Dimensions.height30 * 2,
                                  width: Dimensions.height30 * 2,
                                  child: const Image(
                                      image: AssetImage('assets/images/f.png')),
                                ),
                                SizedBox(width: Dimensions.width20),
                                SizedBox(
                                  height: Dimensions.height30 * 2,
                                  width: Dimensions.height30 * 2,
                                  child: const Image(
                                      image: AssetImage('assets/images/i.png')),
                                ),
                                SizedBox(width: Dimensions.width20),
                                SizedBox(
                                  height: Dimensions.height30 * 2,
                                  width: Dimensions.height30 * 2,
                                  child: const Image(
                                      image: AssetImage('assets/images/g.png')),
                                ),
                                SizedBox(width: Dimensions.width20),
                                SizedBox(
                                  height: Dimensions.height30 * 2,
                                  width: Dimensions.height30 * 2,
                                  child: const Image(
                                      image: AssetImage('assets/images/t.png')),
                                ),
                                SizedBox(width: Dimensions.width20),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              ));
  }

  Widget buildUsername() {
    return TextFormField(
      controller: fullNameController,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: AppColors.secondryDarkColor,
        ),
        labelText: 'Full Name',
        hintText: "Name wtih Surname",
        border: OutlineInputBorder(),
      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return 'Please enter your name';
        } else if (value.length < 6) {
          return 'Please write your full name';
        } else {
          return null;
        }
      }),
      onSaved: (value) {
        setState(() {
          fullNameController.text = value!;
        });
      },
    );
  }

  Widget buildEmail() {
    return TextFormField(
      controller: emailAddressController,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
          ),
          labelText: 'Email Address',
          hintText: "Email",
          prefixIcon: Icon(
            Icons.mail,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        } else if (!(GetUtils.isEmail(value))) {
          return 'Please enter your valid email address';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          emailAddressController.text = value!;
        });
      },
    );
  }

  Widget buildPhone() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneNumberController,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        labelText: 'Phone',
        prefixIcon: Icon(
          Icons.call,
          color: AppColors.secondryDarkColor,
        ),
        hintText: "Phone",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter a Phone number';
        } else if (!GetUtils.isPhoneNumber(value)) {
          return 'Enter a valid phone number';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          phoneNumberController.text = value!;
        });
      },
    );
  }

  Widget buildMessage() {
    return TextFormField(
      controller: messageController,
      maxLines: 4,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
          ),
          labelText: 'Message',
          hintText: "Message",
          prefixIcon: Icon(
            Icons.info,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      validator: ((value) {
        if (value!.isEmpty) {
          return 'Please enter a message';
        } else {
          return null;
        }
      }),
      onSaved: (value) {
        setState(() {
          messageController.text = value!;
        });
      },
    );
  }
}
