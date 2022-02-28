import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cashnote/urls.dart';
import 'package:cashnote/util/http_util.dart';
import 'package:cashnote/util/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cashnote/routes/app_routes.dart';
import 'package:prefs/prefs.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  changePage() async{

    // 첫방문 확인 기본값 false
    var isVisited = await Prefs.getBoolF("isVisited");
    var accessToken = await Prefs.getStringF("access_token");

    /// 첫 방문시 인트로 출력
    if(!isVisited) {
      await Prefs.setBool("isVisited", true);
      Timer(const Duration(milliseconds: 1500), () {
        Get.offAndToNamed(AppRoutes.intro);
      });
    }else {
      /// 로그인토큰 유무 확인
      if(accessToken.isEmpty) {
        Timer(const Duration(milliseconds: 1500), () {
          Get.offAndToNamed(AppRoutes.login);
        });
      }else {
        var requestToken = await HttpUtil().getIsToken(CashNoteAPI.session.url,accessToken);

        /// 토큰이 유효
        if(requestToken){
          Timer(const Duration(milliseconds: 1500), () async {
            /// 안드로이드
            if (Platform.isAndroid) {
              final channel = MethodChannel('method_channel/twa');
              await channel.invokeMethod('openTWA',
                  {"initUrl": MenuAPI.login.url + "?token=$accessToken"});
            /// 아이폰
            } else {
              Get.offAndToNamed(AppRoutes.login); // 로그아웃 눌렀을때 로그인 페이지를 출력해주기 위함
              final iosChannel = MethodChannel('loginHelper');
              iosChannel.invokeMethod("login", {"initUrl": MenuAPI.login.url + "?token=$accessToken"});
            }
          });

        /// 토큰이 만료
        }else {
          await Prefs.remove("access_token");
          Get.offAndToNamed(AppRoutes.login);
        }
      }
    }
  }
}