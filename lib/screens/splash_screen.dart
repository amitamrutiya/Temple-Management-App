import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../routes/route_helper.dart';
import '../utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

firebase_storage.ListResult? result;
List<String> items = ['2018-2019'];

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  void putPdfNameInItem() {
    items.clear();
    result?.items.forEach((firebase_storage.Reference ref) {
      items.add((ref.name).replaceAll('.pdf', ''));
    });
    print(items);
  }

  Future<void> listExample() async {
    result = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .listAll();

    result?.items.forEach((firebase_storage.Reference ref) {
      print('Found file: ${ref.fullPath}');
    });

    result?.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: ${ref.fullPath}');
    });
  }

  @override
  void initState() {
    print(Dimensions.screenHeight);
    print(Dimensions.screenWidth);
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(const Duration(seconds: 3),
        () => Get.offNamed(RouteHelper.getInitial()));
    super.initState();
    () async {
      await listExample();
      // setState(() {
      putPdfNameInItem();
      // });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ScaleTransition(
          scale: animation,
          child: Center(
            child: Image.asset(
              'assets/images/spalsh_screen_1.png',
              width: Dimensions.splashImg,
            ),
          ),
        ),
        Center(
          child: Image.asset('assets/images/spalsh_screen_2.png',
              width: Dimensions.splashImg, fit: BoxFit.cover),
        )
      ]),
    );
  }
}
