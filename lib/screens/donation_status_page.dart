import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple/routes/route_helper.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/dimensions.dart';

class DonationStatusPage extends StatelessWidget {
  final int status;
  const DonationStatusPage({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (status == 0) {
    //   Future.delayed(const Duration(seconds: 1), () {});
    // }
    return Scaffold(
      body: Center(
          child: SizedBox(
              width: Dimensions.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    status == 1
                        ? Icons.check_circle_outline
                        : Icons.warning_outlined,
                    size: 100,
                    color: status == 1 ? AppColors.mainColor : Colors.redAccent,
                  ),
                  SizedBox(height: Dimensions.height30),
                  Text(
                    status == 1
                        ? "We have successfully got your donation \n Keep doing Donation"
                        : "Sorry to Say, Your order Failed",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.height10,
                        vertical: Dimensions.height20),
                    child: Text(
                      status == 1 ? "Successful Order" : "Failed Order",
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: Dimensions.height15),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.height10),
                    child: OutlinedButton(
                      child: status == 1
                          ? Text("Back To Home")
                          : Text("Try Again"),
                      onPressed: status == 1
                          ? (() => Get.offAllNamed(RouteHelper.getInitial()))
                          : ((() => Get.back())),
                    ),
                  )
                ],
              ))),
    );
  }
}
