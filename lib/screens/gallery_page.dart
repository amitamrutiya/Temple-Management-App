import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:temple/utils/dimensions.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int img = 14;
  final controller = CarouselController();
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constant.appBar("Gallery"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CarouselSlider.builder(
              carouselController: controller,
              itemCount: img,
              itemBuilder: ((context, index, realIndex) {
                return Image.asset("assets/images/img${index}.jpg");
              }),
              options: CarouselOptions(
                height: Dimensions.height10 * 55,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: false,
                initialPage: 0,
                viewportFraction: 1,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
            ),
            buildIndicator(),
            SizedBox(height: Dimensions.height20),
            buildButtons(false, activeIndex),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      onDotClicked: animateToSlide,
      effect: SlideEffect(
          dotWidth: Dimensions.width20,
          dotHeight: Dimensions.height20,
          activeDotColor: AppColors.mainColor),
      activeIndex: activeIndex,
      count: img,
    );
  }

  Widget buildButtons(bool stretch, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: previous,
          style: ElevatedButton.styleFrom(
              primary: index == 0
                  ? Theme.of(context).disabledColor
                  : AppColors.mainColor,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15 * 2,
                  vertical: Dimensions.height15)),
          child: Icon(Icons.arrow_back, size: Dimensions.iconSize16 * 2),
        ),
        stretch ? const Spacer() : SizedBox(width: Dimensions.width15 * 2),
        ElevatedButton(
          onPressed: next,
          style: ElevatedButton.styleFrom(
              primary: index == 13
                  ? Theme.of(context).disabledColor
                  : AppColors.mainColor,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15 * 2,
                  vertical: Dimensions.height15)),
          child: Icon(Icons.arrow_forward, size: Dimensions.iconSize16 * 2),
        ),
      ],
    );
  }

  void animateToSlide(int index) {
    controller.animateToPage(index);
  }

  void previous() {
    controller.previousPage();
  }

  void next() {
    controller.nextPage();
  }
}
