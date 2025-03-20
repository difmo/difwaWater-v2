import 'package:difwa/models/address_model.dart';
import 'package:difwa/routes/store_bottom_bar.dart';
import 'package:difwa/routes/user_bottom_bar.dart';
import 'package:difwa/screens/admin_screens/create_store_screen.dart';
import 'package:difwa/screens/auth/adddress_form_page.dart';
import 'package:difwa/screens/auth/login_screen.dart';
import 'package:difwa/screens/auth/signup_screen.dart';
import 'package:difwa/screens/available_service_select.dart';
import 'package:difwa/screens/book_now_screen.dart';
import 'package:difwa/screens/notification_page.dart';
import 'package:difwa/screens/profile_screen.dart';
import 'package:difwa/screens/splash_screen.dart';
import 'package:difwa/screens/subscription_screen.dart';
import 'package:difwa/test.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const splash = '/splash';
  static const availableservices = '/availableservices';
  static const login = '/login';
  static const signUp = '/signup';
  static const otp = '/otp';
  static const userbottom = '/userbottom';
  static const subscription = '/subscription';
  static const address_page = '/address_page';
  static const notification = '/notification_page';

  //////// Admin stuff////////
  static const additem = '/additem';
  static const createstore = '/createstore';
  static const storebottombar = '/storebottombar';
  static const store_home = '/store_home';
  static const store_profile = '/store_profile';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn, // Smooth fade-in for splash screen
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: home,
      page: () => const BookNowScreen(),
      transition: Transition
          .rightToLeftWithFade, // Smooth right-to-left with fade for home screen
      transitionDuration: Duration(milliseconds: 800),
    ),
    GetPage(
      name: profile,
      page: () =>  ProfileScreen(),
      transition: Transition.fadeIn, // Fade transition for profile
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: notification,
      page: () => const NotificationScreen(),
      transition: Transition.fadeIn, // Fade transition for profile
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: availableservices,
      page: () => const AvailableServiceSelect(),
      transition:
          Transition.downToUp, // Slide-up transition for available services
      transitionDuration: Duration(milliseconds: 700),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreenPage(),
      transition: Transition.circularReveal, // Circular reveal effect for login
      transitionDuration: Duration(milliseconds: 1000),
    ),
    GetPage(
      name: signUp,
      page: () => const MobileNumberPage(),
      transition: Transition.circularReveal, // Circular reveal effect for login
      transitionDuration: Duration(milliseconds: 1000),
    ),
    GetPage(
      name: userbottom,
      page: () => const BottomUserHomePage(),
      transition: Transition
          .rightToLeft, // Slide transition from right for user dashboard
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: subscription,
      page: () => const SubscriptionScreen(),
      transition: Transition.zoom, // Zoom transition for subscription screen
      transitionDuration: Duration(milliseconds: 800),
    ),

    /////////////////////////Admin Routes/////////////////
    GetPage(
      name: createstore,
      page: () => const CreateStorePage(),
      transition: Transition.fadeIn, // Smooth fade-in for create store page
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: storebottombar,
      page: () => const BottomStoreHomePage(),
      transition: Transition
          .leftToRight, // Slide transition from left for store dashboard
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: address_page,
      page: () => AddressForm(
        address: Address(
            docId: "",
            name: "",
            street: "",
            city: "",
            state: "",
            zip: "",
            isDeleted: false,
            isSelected: false,
            country: "",
            phone: "",
            saveAddress: false,
            userId: "",
            floor: ""),
        flag: "",
      ),
      transition: Transition.fadeIn, // Smooth fade-in for store home screen
      transitionDuration: Duration(milliseconds: 500),
    ),
  ];
}
