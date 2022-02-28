import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cashnote/constants.dart';
import 'package:cashnote/routes/app_routes.dart';
import 'package:cashnote/urls.dart';

class Intro extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Color(0xfff5f5f5),
          child: Column(
            children: <Widget>[
              SizedBox(height: 67.4.h,),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "3단계로 끝나는 간편한 광고",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: Constants.SpoqaHanSansNeoRegular,
                    letterSpacing: -0.36.sp,
                    color: const Color(0xff767676),
                  ),
                ),
              ),
              SizedBox(height: 5.6.h,),
              Container(
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(Constants.NOTI_I_LOGO),
                  height: 32.h,
                ),
              ),
              SizedBox(height: 82.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  main_icon("회원 가입 하고", 1),
                  main_icon("비용 충전 하고", 2),
                  main_icon("광고 설정 하면", 3),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {Get.offAllNamed(AppRoutes.login);},
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "광고 시작하기!",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: Constants.SpoqaHanSansNeoBold,
                        letterSpacing: -0.36.sp,
                        color: const Color(0xff1c1c1c)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 170.h,),
            ],
          ),
        ),
      ),
    );
  }

  Widget main_icon(String title,int index) {
    return Column(
      children: [
        Image(
          image: AssetImage(Constants.IMG_PATH + "main_icon_0$index.png"),
          width: 82.w,
        ),
        SizedBox(height: 14.h,),
        Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: Constants.SpoqaHanSansNeoRegular,
              letterSpacing: -0.28.sp,
              color: const Color(0xff1c1c1c)
          ),
        )
      ],
    );
  }


  /**
   * 첫 intro 시안
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 120.h),
              Image.asset(
                Constants.NOTI_I_LOGO,
                height: 20.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "안녕하세요\n노티아이입니다",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontFamily: Constants.SpoqaHanSansNeoBold,
                  height: (38/26).sp,
                  letterSpacing: -0.52.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text("캐시노트 사장님들을 위한 광고 서비스!\n내 매장 근처를 지나가는 손님에게\n광고메시지를 보내드려요.\n(본 서비스는 캐시노트 전용 서비스입니다.)",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Constants.SpoqaHanSansNeoRegular,
                  height: (20/14).sp,
                  letterSpacing: -0.28.sp,
                  color: const Color(0xff767676)
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: GestureDetector(
                  onTap: (){
                    Get.offAllNamed(AppRoutes.login);

                    // if(Platform.isAndroid) {
                    //   Get.offAllNamed(AppRoutes.androidWeb);
                    // }else {
                    //   Get.offAllNamed(AppRoutes.iosWeb);
                    // }

                    // FlutterWebBrowser.openWebPage(
                    //   url: "https://dev.cashnote.tdi9.com/",
                    //   customTabsOptions: const CustomTabsOptions(
                    //     colorScheme: CustomTabsColorScheme.dark,
                    //     shareState: CustomTabsShareState.on,
                    //     instantAppsEnabled: true,
                    //     showTitle: true,
                    //     urlBarHidingEnabled: true,
                    //   ),
                    // );

                  },
                  child: Container(
                    width: 328.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff00b1bb),
                      borderRadius: BorderRadius.all(Radius.circular(6.r))
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "시작하기",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: Constants.SpoqaHanSansNeoBold,
                        letterSpacing: -0.28.sp,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
      */
}
