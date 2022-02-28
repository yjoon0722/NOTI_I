import 'package:get/get.dart';
import 'package:cashnote/binding/login_binding.dart';
import 'package:cashnote/binding/splash_binding.dart';
import 'package:cashnote/routes/app_routes.dart';
import 'package:cashnote/view/intro.dart';
import 'package:cashnote/view/login.dart';
import 'package:cashnote/view/splash.dart';

class AppPages {
  static var list = [
    // splash
    GetPage(
      name: AppRoutes.splash,
      page: () => Splash(),
      binding: SplashBinding()
    ),

    // intro
    GetPage(
      name: AppRoutes.intro,
      page: () => Intro(),
    ),

    // Login
    GetPage(
      name: AppRoutes.login,
      page: () => Login(),
      binding: LoginBinding(),
    ),

  ];
}