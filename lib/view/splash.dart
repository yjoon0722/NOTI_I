import 'package:cashnote/constants.dart';
import 'package:cashnote/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Splash extends GetView<SplashController> {

  @override
  Widget build(BuildContext context) {
    controller.changePage();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          alignment: Alignment.center,
          child: Image.asset(
            Constants.IMG_PATH + "noti_i_logo.png",
            height: 34.h,
          )
      ),
    );
  }
}
