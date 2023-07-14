import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple/firebase_options.dart';
import 'package:temple/routes/route_helper.dart';
import 'package:temple/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temple',
      // home: RoughWork(),
      initialRoute: RouteHelper.getSplashPage(),
      getPages: RouteHelper.routes,
      theme: ThemeData(
        primaryColor: AppColors.mainColor,
        primarySwatch: Colors.blueGrey,
        fontFamily: "Lato",
      ),
    );
  }
}
