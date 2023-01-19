import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple/models/donation_model.dart';
import 'package:temple/screens/donation_status_page.dart';
import 'package:temple/utils/secret.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/constant.dart';
import 'package:temple/utils/dimensions.dart';
import 'package:temple/widget/big_text.dart';
import 'package:temple/widget/show_custom_snakbar.dart';
import 'package:temple/widget/small_text.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DontaionPage extends StatefulWidget {
  const DontaionPage({Key? key}) : super(key: key);

  @override
  State<DontaionPage> createState() => _DontaionPageState();
}

class _DontaionPageState extends State<DontaionPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController donationAmountController = TextEditingController();
  TextEditingController donationCommentsController = TextEditingController();

  bool isAnonymous = false;
  bool _isLoading = false;

  Razorpay _razorpay = Razorpay();

  void _openCheckout() {
    var options = {
      'key': SECRET.RAZORPAY_SECRED_ID,
      'amount': num.parse(donationAmountController.text) * 100,
      'name': 'GSFC Organization',
      'description': 'Payment for Your Temple Doantion',
      'prefill': {'contact': "+918141749739", 'email': "donation@gsfc.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  Future sendMail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(
        {
          'service_id': SECRET.DONATION_SERVICE_ID,
          'template_id': SECRET.DONATION_TEMPLATE_ID,
          'user_id': SECRET.DONATION_USER_ID,
          'template_params': {
            'full_name': fullNameController.text,
            'address': addressController.text,
            'country': countryController.text,
            'donation_amount': donationAmountController.text,
            'donation_message': donationCommentsController.text,
            'email_address': emailAddressController.text,
            'phone_number': phoneNumberController.text,
            'is_anonymous': !isAnonymous,
          },
          'accessToken': "6xctMol37DLDtlHVif-W7"
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // print("RazorSuccess : " + response.paymentId! + "--" + response.orderId!);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const DonationStatusPage(status: 1)),
    );
    await addDonationForm();
    await sendMail();
    fullNameController.clear();
    emailAddressController.clear();
    phoneNumberController.clear();
    addressController.clear();
    countryController.clear();
    donationAmountController.clear();
    donationCommentsController.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("RazorypayError : " +
        response.code.toString() +
        "--" +
        response.message!);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const DonationStatusPage(status: 0)),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("RazorWallet : " + response.walletName!);
  }

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  CollectionReference donation =
      FirebaseFirestore.instance.collection('donation');

  Future<void> addDonationForm() {
    DonationModel form = DonationModel(
      fullName: fullNameController.text,
      emailAddress: emailAddressController.text,
      phoneNumber: phoneNumberController.text,
      message: donationCommentsController.text,
      submitedAt: DateTime.now(),
      amount: double.parse(donationAmountController.text),
      address: addressController.text,
      country: countryController.text,
      isAnonymous: isAnonymous,
    );
    return donation.add(form.toJson()).then((_) async {
      print("got data");
    }).catchError((error) {
      showCustomSnakBar("An error occured", title: "Attentation");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: Constant.appBar("Donation"),
        body: !_isLoading
            ? Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.width10),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius20 / 3)),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                  text: "Your Information",
                                  size: Dimensions.font26),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Dimensions.width15),
                                child: SmallText(
                                  text: "Name",
                                  size: Dimensions.font20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildUsername(),
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: SmallText(
                                    text: "Email Address",
                                    size: Dimensions.font20,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildEmail(),
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: SmallText(
                                    text: "Phone Number",
                                    size: Dimensions.font20,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildPhone(),
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: SmallText(
                                    text: "Address",
                                    size: Dimensions.font20,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildAddress(),
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: SmallText(
                                    text: "Country",
                                    size: Dimensions.font20,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildCountry(),
                              ),
                              SizedBox(height: Dimensions.height20),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius20 / 3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                text: "Donation Information",
                                size: Dimensions.font26,
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SmallText(
                                  text: " May we thank you publicly?",
                                  size: Dimensions.font20,
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: AppColors.mainColor,
                                    value: isAnonymous,
                                    onChanged: (value) {
                                      setState(() {
                                        isAnonymous = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      "No, please keep my information anonymous",
                                      style: TextStyle(
                                          fontSize: Dimensions.iconSize16),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: SmallText(
                                    text: "Donation",
                                    size: Dimensions.font20,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildDonation(),
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: SmallText(
                                    text: "Donation Comments",
                                    size: Dimensions.font20,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20),
                                child: buildDonationComments(),
                              ),
                              SizedBox(height: Dimensions.height20),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Dimensions.height20),
                              Center(
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height20,
                                      horizontal: Dimensions.width20),
                                  color: AppColors.mainColor,
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
                                        _openCheckout();

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
                                    "Confirm Order",
                                    style: TextStyle(
                                      fontSize: Dimensions.font20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(color: AppColors.mainColor)));
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
        if (isAnonymous == false) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          } else if (value.length < 6) {
            return 'Please write your full name';
          } else {
            return null;
          }
        } else
          return null;
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
          counterText:
              "If you want receipt of donation then enter correct email id   ",
          labelText: 'Email Address',
          hintText: "Email",
          prefixIcon: Icon(
            Icons.mail,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (isAnonymous == false) {
          if (value!.isEmpty) {
            return 'Please enter your email';
          } else if (!(GetUtils.isEmail(value))) {
            return 'Please enter your valid email address';
          } else {
            return null;
          }
        } else
          return null;
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
        if (isAnonymous == false) {
          if (value!.isEmpty) {
            return 'Enter a Phone number';
          } else if (!GetUtils.isPhoneNumber(value)) {
            return 'Enter a valid phone number';
          }
          return null;
        } else
          return null;
      },
      onSaved: (value) {
        setState(() {
          phoneNumberController.text = value!;
        });
      },
    );
  }

  Widget buildAddress() {
    return TextFormField(
      controller: addressController,
      maxLines: 2,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
          ),
          labelText: 'Address',
          hintText: "Home Address",
          prefixIcon: Icon(
            Icons.location_on,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      onSaved: (value) {
        setState(() {
          addressController.text = value!;
        });
      },
    );
  }

  Widget buildCountry() {
    return TextFormField(
      controller: countryController,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
          ),
          labelText: 'Country',
          hintText: "Your Country",
          prefixIcon: Icon(
            Icons.location_city,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      onSaved: (value) {
        setState(() {
          countryController.text = value!;
        });
      },
    );
  }

  Widget buildDonation() {
    return TextFormField(
      controller: donationAmountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
          ),
          labelText: 'Amount',
          hintText: "Amount In INR (₹)",
          prefixIcon: Icon(
            Icons.money,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter an Amount for your donation";
        }
        if (value.contains(" ") || !value.isNum) {
          return 'Enter a valid number';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          donationAmountController.text = value!;
        });
      },
    );
  }

  Widget buildDonationComments() {
    return TextFormField(
      controller: donationCommentsController,
      maxLines: 3,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
          ),
          labelText: 'Comments',
          hintText: "Extra Message For Your Donation",
          prefixIcon: Icon(
            Icons.info,
            color: AppColors.secondryDarkColor,
          ),
          border: OutlineInputBorder()),
      onSaved: (value) {
        setState(() {
          donationCommentsController.text = value!;
        });
      },
    );
  }
}
