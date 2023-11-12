import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple/routes/route_helper.dart';
import 'package:temple/utils/constant.dart';
import 'package:temple/utils/dimensions.dart';
import 'package:temple/widget/drawer.dart';

import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List source = [1, 2, 3];
  PageController pageController = PageController(viewportFraction: 0.85);
  var currPageValue = 0.0;
  double scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      drawer: CustomeDrawer(),
      appBar: Constant.appBar("FERTILIZER TOWNSHIP"),
      body: Column(
        children: [
          //slider section
          Column(
            children: [
              //Slider Section
              SizedBox(height: Dimensions.height20),
              SizedBox(
                height: _height,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: source.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position, source[position]);
                    }),
              ),
              SizedBox(height: Dimensions.height10),
              //dots
              DotsIndicator(
                dotsCount: source.length,
                position: currPageValue,
                decorator: DotsDecorator(
                    activeColor: AppColors.mainColor,
                    size: const Size.square(9),
                    activeSize: const Size(18, 9),
                    activeShape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20))),
              ),
            ],
          ),
          //body section
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                decoration: BoxDecoration(
                  color: AppColors.secondryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Text(
                  "HAR HAR",
                  style: TextStyle(
                      fontSize: Dimensions.font26 * 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                decoration: BoxDecoration(
                  color: AppColors.secondryDarkColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Text(
                  "MAHADEV",
                  style: TextStyle(
                      color: AppColors.yellowColor,
                      fontSize: Dimensions.font20 * 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Text(
                  "Temple of Lord Shiva",
                  style: TextStyle(
                      fontSize: Dimensions.font26, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: Dimensions.height30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height20,
                        horizontal: Dimensions.width20),
                    backgroundColor: AppColors.mainColor,
                  ),
                  onPressed: () {
                    Get.toNamed(RouteHelper.getAboutUsPage());
                  },
                  child: Text(
                    "More Details",
                    style: TextStyle(
                        fontSize: Dimensions.font20, color: Colors.white),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(int index, popularProduct) {
    Matrix4 matrix = Matrix4.identity();
    if (index == currPageValue.floor()) {
      var currScale = 1 - (currPageValue - index) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (currPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currPageValue.floor() - 1) {
      var currScale = 1 - (currPageValue - index) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - scaleFactor) / 2, 0);
    }
    return Transform(
      transform: matrix,
      child: Container(
        height: Dimensions.pageViewContainer,
        margin: EdgeInsets.only(
            left: Dimensions.width10, right: Dimensions.width10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            color: index.isEven
                ? const Color(0xff69c5df)
                : const Color(0xff9294cc),
            image: DecorationImage(
                image: AssetImage("assets/images/Slider-img${index + 1}.jpg"),
                fit: BoxFit.cover)),
      ),
    );
  }
}
