import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/widget/big_text.dart';
import 'package:temple/widget/small_text.dart';

import '../../utils/dimensions.dart';

List<Widget> aboutUs = <Widget>[
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height10),
          decoration: BoxDecoration(
              color: AppColors.iconColor1,
              borderRadius: BorderRadius.circular(Dimensions.radius30)),
          child: BigText(
            text: "INTRODUCTION",
            size: Dimensions.font20 * 2,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        const Text(
            '''GSFC (Sikka Unit) has started its DAP Production in 1987 at Motikhavdi on Jamnagar - Dwarka highway at a distance of around 27 Kms, from Jamnagar. The company has also constructed its own township having 192 quarters near to the plant for the residents of officers and staff.\n
It was decided to construct a temple inside the township so that the residents of colony can actively take part in the religious overall activity. For the purpose, a Fertilizer Township Charitable Trust was established in 1989 having its Registration No. E-796 Jamnagar dtd.10.02.1989. All the employees are contributing every month.\n
With the donations from well-wishers who came forward from time to time and as a result a “Shiva Temple” was constructed and its Pran Pratishtha was celebrated on “Mahashivratri day” i.e. on 25.02.1998. As per the plan, the construction of other 7 small temples dedicated to various god, goddess also completed around the main “Shiva Temple” in the year 2004. The “Pran Pratishtha Mahotsav” of these 7 temples was celebrated from 31.10.04 to 02.11.04.\n''')
      ],
    ),
  ),
  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height10),
          decoration: BoxDecoration(
              color: AppColors.iconColor1,
              borderRadius: BorderRadius.circular(Dimensions.radius30)),
          child: Center(
            child: Text(
              "TRUSTIES",
              style: TextStyle(
                  fontSize: Dimensions.font20 * 2, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: Dimensions.height30),
        Text(
          "NAME OF THE TRUSTIES ARE :",
          style: TextStyle(
              fontSize: Dimensions.font20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: Dimensions.height20 / 1.5),
        Padding(
          padding: EdgeInsets.only(left: Dimensions.width30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallText(
                text: "1) Shri GM Patel - Chairman",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "2) Shri AJ Kulabkar - Secretary",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "3) Shri PD Rindani - Treasurer",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "4) Shri SA Desai - Member",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "5) Shri MM Patel",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "6) Shri MJ Acharya",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "7) ShriPA Pandya",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "8) Shri AN Gohil",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "9) Shri RL Dandekar",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "10) Shri MS Bhatt",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "11) Shri RM Rathod",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
              SmallText(
                text: "12) Shri MB Desai",
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height10 / 2),
            ],
          ),
        ),
      ])),
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height10),
          decoration: BoxDecoration(
              color: AppColors.iconColor1,
              borderRadius: BorderRadius.circular(Dimensions.radius30)),
          child: BigText(
            text: "DONATORS",
            size: Dimensions.font20 * 2,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Image(
          height: Dimensions.height10 * 36,
          image: const AssetImage('assets/images/about-img2.jpg'),
          fit: BoxFit.cover,
        ),
        SizedBox(height: Dimensions.height10),
        Column(
          children: [
            SmallText(
              text: "3%-Income Golakh",
              size: Dimensions.font16,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            SmallText(
              text: "10%-Donation through salary of employees",
              size: Dimensions.font16,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            SmallText(
              text: "12%-Interst",
              size: Dimensions.font16,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            SmallText(
              text: "75%-Donation by the worshipers",
              size: Dimensions.font16,
            ),
            SizedBox(height: Dimensions.height10 / 2),
          ],
        )
      ],
    ),
  ),
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height10),
          decoration: BoxDecoration(
              color: AppColors.iconColor1,
              borderRadius: BorderRadius.circular(Dimensions.radius30)),
          child: BigText(
            text: "Expenses",
            size: Dimensions.font20 * 2,
          ),
        ),
        SizedBox(height: Dimensions.height15),
        const Image(
          image: AssetImage('assets/images/about-img3.png'),
          fit: BoxFit.cover,
        )
      ],
    ),
  )
];

class AboutUsBody extends StatefulWidget {
  const AboutUsBody({Key? key}) : super(key: key);

  @override
  State<AboutUsBody> createState() => _AboutUsBodyState();
}

class _AboutUsBodyState extends State<AboutUsBody> {
  final controller = CarouselController();
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          itemCount: aboutUs.length,
          itemBuilder: ((context, index, realIndex) {
            return aboutUs[index];
          }),
          options: CarouselOptions(
            height: Dimensions.height10 * 65,
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
      count: aboutUs.length,
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
              primary: index == 3
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
