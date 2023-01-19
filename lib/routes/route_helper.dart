import 'package:get/get.dart';
import 'package:temple/screens/contact_us_page.dart';
import 'package:temple/screens/donation_page.dart';
import 'package:temple/screens/gallery_page.dart';
import 'package:temple/screens/donation_status_page.dart';
import 'package:temple/screens/slot_booking/slot_booking_page.dart';

import '../screens/about_us/about_us_page.dart';
import '../screens/circulars_page.dart';
import '../screens/home_page.dart';
import '../screens/splash_screen.dart';

class RouteHelper {
  static const String splashPage = '/splash-page';
  static const String initial = '/';
  static const String aboutUsPage = '/about-us-page';
  static const String contactUsPage = '/contact-us-page';
  static const String galleryPage = '/gallery-page';
  static const String donationPage = '/donation-page';
  static const String slotBookPage = '/slot-book-page';
  static const String dontaionSuccessPage = '/donation-success-page';
  static const String circularPage = '/circular-page';

  static String getSplashPage() => splashPage;
  static String getInitial() => initial;
  static String getAboutUsPage() => aboutUsPage;
  static String getContactUsPage() => contactUsPage;
  static String getDonationPage() => donationPage;
  static String getGalleryPage() => galleryPage;
  static String getSlotBookPage() => slotBookPage;
  static String getDonationStatusPage() => dontaionSuccessPage;
  static String getCircularPage() => circularPage;

  static List<GetPage> routes = [
    GetPage(
        name: splashPage,
        page: () => const SplashScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: initial,
        page: () => const HomePage(),
        transition: Transition.fadeIn),
    GetPage(
      name: aboutUsPage,
      page: () => const AboutUsPage(),
    ),
    GetPage(
      name: contactUsPage,
      page: () => ContactUsPage(),
    ),
    GetPage(
      name: donationPage,
      page: () => const DontaionPage(),
    ),
    GetPage(
      name: galleryPage,
      page: () => const GalleryPage(),
    ),
    GetPage(
      name: contactUsPage,
      page: () => const ContactUsPage(),
    ),
    GetPage(
      name: slotBookPage,
      page: () => SlotBookingPage(),
    ),
    GetPage(
      name: dontaionSuccessPage,
      page: () => DonationStatusPage(status: 1),
    ),
    GetPage(
      name: circularPage,
      page: () => CircularPage(),
    )
  ];
}
