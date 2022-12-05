import 'package:flutter/material.dart';
import 'package:temple/screens/about_us/about_us_body.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/constant.dart';
import 'package:temple/utils/dimensions.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutQuint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      appBar: Constant.appBar("About US"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Dimensions.height10),
              ScaleTransition(
                scale: animation,
                child: Container(
                  height: Dimensions.height10 * 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("assets/images/about-img1.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15,
                    ),
                  ),
                ),
              ),
              const AboutUsBody(),
            ],
          ),
        ),
      ),
    );
  }
}
