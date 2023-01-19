import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple/utils/secret.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/constant.dart';
import 'package:temple/utils/dimensions.dart';
import 'package:temple/widget/big_text.dart';
import 'package:temple/widget/show_custom_snakbar.dart';
// import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

class SlotBookingPage extends StatefulWidget {
  SlotBookingPage({Key? key}) : super(key: key);

  @override
  State<SlotBookingPage> createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  // List<String> name = [
  //   "Parth Adeshara",
  //   "Bhavik Ambasara",
  //   "Amit Amrutiya",
  //   "Vrushabh Amrutiya",
  //   "Harsh Avichal",
  //   "Kunj Bapodariya",
  //   "Kush Bhalodiya",
  //   "Vedant Bhatt",
  //   "Mit Butani",
  //   "Riken Goyani",
  //   "Maharshi Kevadiya",
  //   "Mann Chandarana",
  //   "Dev Desai",
  // ];
  // static String _selectedPujari = "Click on Me";
  // static String get selectedPujari => _selectedPujari;

  StreamController<String> selectedPujariController = StreamController();
  final _formKey = GlobalKey<FormState>();
  var pickDateController = TextEditingController();
  var pickTimeController = TextEditingController();
  var descriptionController = TextEditingController();
  var poojnameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  var fullNameController = TextEditingController();
  // final Telephony telephony = Telephony.instance;
  @override
  void dispose() {
    pickDateController.dispose();
    pickTimeController.dispose();
    descriptionController.dispose();
    poojnameController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();

    super.dispose();
  }

  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Scaffold(
            appBar: Constant.appBar("Book A Slot"),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height20),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //chosoe date field
                      BigText(text: "Your Name"),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.height10,
                            vertical: Dimensions.width10),
                        child: buildUsername(),
                      ),
                      BigText(text: "Your Phone Number"),

                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.height10,
                            vertical: Dimensions.width10),
                        child: buildPhone(),
                      ),
                      BigText(text: "Select Date"),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10,
                            vertical: Dimensions.height10),
                        child: buildDateTextField(),
                      ),
                      //chose time field
                      BigText(text: "Select Time"),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.height10,
                            vertical: Dimensions.width10),
                        child: buildTimeTextField(),
                      ),
                      //choose Pandit name
                      // BigText(text: "Select Pujari"),
                      // SizedBox(height: Dimensions.height10),
                      // // StreamBuilder<Object>(
                      //     stream: selectedPujariController.stream,
                      //     builder: (context, snapshot) {
                      //       return InkWell(
                      //         onTap: () async {
                      //           await _showListOfPujari(context);
                      //         },
                      //         child: Container(
                      //           alignment: Alignment.centerLeft,
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: Dimensions.width20),
                      //           margin: EdgeInsets.symmetric(
                      //               horizontal: Dimensions.width10),
                      //           width: double.infinity,
                      //           height: Dimensions.height10 * 7.5,
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(
                      //                   Dimensions.radius15 / 2),
                      //               border: _selectedPujari == "Click on Me"
                      //                   ? Border.all(
                      //                       width: 2,
                      //                       color: Theme.of(context).disabledColor)
                      //                   : Border.all(
                      //                       width: 2,
                      //                       color: AppColors.secondryDarkColor)),
                      //           child: Text(_selectedPujari,
                      //               style: TextStyle(
                      //                 color: _selectedPujari == "Click on Me"
                      //                     ? Theme.of(context).disabledColor
                      //                     : Colors.black,
                      //                 fontWeight: FontWeight.w400,
                      //                 fontSize: Dimensions.font20,
                      //               )),
                      //         ),
                      //       );
                      //     }),
                      // SizedBox(height: Dimensions.height10),
                      BigText(text: "Name Of Pooja"),

                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.height10,
                            vertical: Dimensions.width10),
                        child: buildNameOfPooja(),
                      ),
                      BigText(text: "Description of Pooja"),

                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.height10,
                            vertical: Dimensions.width10),
                        child: buildDescription(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.height20 * 3),
                        child: ButtonTheme(
                          height: Dimensions.height30 * 1.7,
                          child: RaisedButton(
                            color: AppColors.mainColor,
                            onPressed: () async {
                              if (ConnectivityResult.none !=
                                  await Connectivity().checkConnectivity()) {
                                final isValid =
                                    _formKey.currentState!.validate();
                                FocusScope.of(context).unfocus();
                                // if (_selectedPujari == "Click on Me") {
                                //   showCustomSnakBar("Please Select Pujari",
                                //       title: "Attention");
                                // }
                                // if (isValid && _selectedPujari != "Click on Me")
                                // final bool? result =
                                // await telephony.requestPhoneAndSmsPermissions;
                                if (isValid) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // "Yajman Name : ${fullNameController.text} \n Yajman PhoneNumber : ${phoneNumberController.text} \n Name of Pooja : ${poojnameController.text} \n Date for Pooja : ${pickDateController.text} \n Pooja Time : ${pickTimeController.text} \n Extra Message : ${descriptionController.text}")
                                  await sendMail();
                                  pickDateController.clear();
                                  pickTimeController.clear();
                                  phoneNumberController.clear();
                                  fullNameController.clear();
                                  poojnameController.clear();
                                  descriptionController.clear();
                                  // _selectedPujari = "Click on Me";
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Get.snackbar("All went Perfect",
                                      "We got Your Information");
                                }
                              } else {
                                showCustomSnakBar(
                                    "Please Turn on Your Internet",
                                    title: "Attention");
                              }
                            },
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: Dimensions.font20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  // _showListOfPujari(BuildContext context) async {
  //   showDialog(
  //                         context: context,
  //                         builder: (context) {
  //                           return StatefulBuilder(
  //                             builder: ((context, setState) {
  //                               return Center(
  //                                   child: Container(
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.circular(
  //                                       Dimensions.radius20),
  //                                 ),
  //                                 height: MediaQuery.of(context).size.height *
  //                                     0.85,
  //                                 width: MediaQuery.of(context).size.width *
  //                                     0.85,
  //                                 child: ListView.builder(
  //                                   itemCount: name.length,
  //                                   itemBuilder: ((context, index) {
  //                                     return Material(
  //                                       child: RadioListTile(
  //                                         value: name[index],
  //                                         groupValue: _selectedPujari,
  //                                         onChanged: (value) async {
  //                                           setState(() {
  //                                             _selectedPujari =
  //                                                 value.toString();
  //                                             selectedPujariController.sink
  //                                                 .add(_selectedPujari);
  //                                           });
  //                                           await Future.delayed(
  //                                               Duration(milliseconds: 300));
  //                                           Navigator.pop(context);
  //                                         },
  //                                         title: BigText(text: name[index]),
  //                                       ),
  //                                     );
  //                                   }),
  //                                 ),
  //                               ));
  //                             }),
  //                           );
  //                         },
  //                       );
  // }

  Widget buildDateTextField() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: pickDateController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        labelText: 'Pick Date',

        suffixIcon: CircleAvatar(
          radius: Dimensions.radius20 * 5 / 4,
          backgroundColor: AppColors.pageColor,
          child: IconButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2023),
              );
              if (newDate == null) return;
              setState(() {
                pickDateController.text =
                    DateFormat('dd/MM/yyyy').format(newDate);
              });
            },
            icon: Icon(Icons.date_range),
            color: AppColors.secondryDarkColor,
          ),
        ),
        // prefixIcon: Icon(
        //   Icons.timer,
        //   color: AppColors.secondryDarkColor,
        // ),
        hintText: "DD/MM/YYYY",
        border: OutlineInputBorder(),
      ),
      cursorColor: AppColors.mainColor,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please choose a date';
        }
        if (!value.contains("/")) {
          return 'Please select valid Date';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          pickDateController.text = value!;
        });
      },
    );
  }

  Widget buildTimeTextField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: pickTimeController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        labelText: 'Pick Time',
        suffixIcon: CircleAvatar(
          radius: Dimensions.radius20 * 5 / 4,
          backgroundColor: AppColors.pageColor,
          child: IconButton(
            onPressed: () async {
              TimeOfDay? newTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay(hour: 0, minute: 0));
              if (newTime == null) return;
              setState(() {
                pickTimeController.text =
                    MaterialLocalizations.of(context).formatTimeOfDay(newTime);
              });
            },
            icon: Icon(Icons.timer),
            color: AppColors.secondryDarkColor,
          ),
        ),
        hintText: "HH:MM AM/PM ",
        border: OutlineInputBorder(),
      ),
      cursorColor: AppColors.mainColor,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please choose a Time ';
        }
        if (!value.contains(":") ||
            (!(value.contains("AM") || value.contains("PM")))) {
          return 'Please select valid Time';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          pickTimeController.text = value!;
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
      // onSaved: (value) {
      // setState(() {
      //   phoneNumberController.text = value!;
      // });
      // },
    );
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
      // onSaved: (value) {
      //   setState(() {
      //     fullNameController.text = value!;
      //   });
      // },
    );
  }

  Widget buildNameOfPooja() {
    return TextFormField(
      controller: poojnameController,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        prefixIcon: Icon(
          Icons.fireplace,
          color: AppColors.secondryDarkColor,
        ),
        labelText: 'Pooja',
        hintText: "Name of Pooja",
        border: OutlineInputBorder(),
      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return 'Please enter name';
        } else {
          return null;
        }
      }),
      // onSaved: (value) {
      //   setState(() {
      //     fullNameController.text = value!;
      //   });
      // },
    );
  }

  Widget buildDescription() {
    return TextFormField(
      maxLines: 3,
      controller: descriptionController,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        prefixIcon: Icon(
          Icons.info,
          color: AppColors.secondryDarkColor,
        ),
        labelText: 'Description ',
        hintText: "Description about pooja",
        border: OutlineInputBorder(),
      ),
      // validator: ((value) {
      //   if (value!.isEmpty) {
      //     return 'Please enter description';
      //   } else {
      //     return null;
      //   }
      // }),
      // onSaved: (value) {
      //   setState(() {
      //     fullNameController.text = value!;
      //   });
      // },
    );
  }

  Future sendMail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(
        {
          'service_id': SECRET.SLOT_BOOKING_SERVICE_ID,
          'template_id': SECRET.SLOT_BOOKING_TEMPLATE_ID,
          'user_id': SECRET.SLOT_BOOKING_USER_ID,
          'template_params': {
            'full_name': fullNameController.text,
            'message': descriptionController.text,
            'pooja_name': poojnameController.text,
            'pooja_time': pickTimeController.text,
            'pooja_date': pickDateController.text,
            'phone_number': phoneNumberController.text,
          }
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    return response;
  }
}
