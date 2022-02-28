import 'dart:convert';
import 'dart:io';

import 'package:cashnote/constants.dart';
import 'package:cashnote/routes/app_routes.dart';
import 'package:cashnote/util/toast_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cashnote/urls.dart';
import 'package:cashnote/util/http_util.dart';
import 'package:prefs/prefs.dart';

class LoginController extends GetxController {
  TextEditingController? idController;
  TextEditingController? pwController;

  final iosChannel = MethodChannel('loginHelper');

  final focusNode = FocusScopeNode();

  @override
  void onInit() {
    super.onInit();
    isObscure.value = true;
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  @override
  void onClose() {
    idController?.dispose();
    pwController?.dispose();
    super.onClose();
  }

  var isObscure = true.obs;

  void changeIsObscure() {
    isObscure.value = !isObscure.value;
  }

  /// 로그인
  Future<void> login(BuildContext context) async{
    var param = {
      "email" : idController?.text,
      "password" : pwController?.text,
    };

    var requestLogin = await HttpUtil().postLogin(CashNoteAPI.login.url, param);

    if(requestLogin.isNotEmpty) {
      var json = jsonDecode(requestLogin);
      // 로그인 성공시
      if (json['success'] == true) {
        String accessToken = json['access_token'];
        await Prefs.setString('access_token', accessToken);

        var fcmToken = await FirebaseMessaging.instance.getToken();
        var fcmBody = {
          "token": fcmToken,
          "type": Platform.isAndroid ? "Android" : "IOS",
          "agent": "cashnote"
        };
        try {
          await HttpUtil().postFCM(CashNoteAPI.fcm.url, fcmBody, accessToken);
        } catch (e) {
          print(e.toString());
        }

        /// 로그인 성공 팝업창 띄우기
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(0),
              child: SizedBox(
                width: 328.w,
                height: 219.h,
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Image.asset(
                      Constants.IMG_PATH + "pass.png",
                      height: 26.h,
                    ),
                    SizedBox(height: 26.h),
                    Text(
                      "로그인 성공",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: Constants.SpoqaHanSansNeoBold,
                        letterSpacing: -0.02.sp,
                        color: const Color(0xff1c1c1c)
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "노티아이로 성공적인 비지니스를 시작하세요!",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: Constants.SpoqaHanSansNeoRegular,
                        letterSpacing: -0.28.sp,
                        color: const Color(0xff767676)
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(0,0,20.w,9.h),
                      child: TextButton(
                        onPressed: () async{
                          Navigator.pop(context);
                          /// 안드로이드
                          if (Platform.isAndroid) {
                            final channel = MethodChannel('method_channel/twa');
                            await channel.invokeMethod('openTWA', {"initUrl": MenuAPI.login.url + "?token=$accessToken"});
                            /// 아이폰
                          } else {
                            idController!.text = "";
                            pwController!.text = "";
                            iosChannel.invokeMethod("login", {"initUrl": MenuAPI.login.url + "?token=$accessToken"});
                          }
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: Constants.SpoqaHanSansNeoMedium,
                              letterSpacing: -0.28.sp,
                              color: const Color(0xff00b1bb)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      } else {
        /// 로그인 실패 팝업창 띄우기
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(0),
              child: SizedBox(
                height: 219.h,
                width: 328.w,
                child: Column(
                  children: [
                    SizedBox(height: 31.h),
                    Image.asset(
                      Constants.IMG_PATH + "warning.png",
                      height: 44.h,
                    ),
                    SizedBox(height: 17.h),
                    Text(
                      "로그인 실패",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: Constants.SpoqaHanSansNeoBold,
                        letterSpacing: -0.02.sp,
                        color: const Color(0xff1c1c1c)
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "비밀번호를 확인해주세요",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: Constants.SpoqaHanSansNeoRegular,
                        letterSpacing: -0.28.sp,
                        color: const Color(0xff767676)
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(0,0,20.w,9.h),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: Constants.SpoqaHanSansNeoMedium,
                              letterSpacing: -0.28.sp,
                              color: const Color(0xff00b1bb)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    }
  }

  /// 아이디찾기,비밀번호찾기
  Future<void> find(String initUrl) async{
    var fcmToken = await FirebaseMessaging.instance.getToken();

    /// 안드로이드
    if (Platform.isAndroid) {
      final channel = MethodChannel('method_channel/twa');
      channel.invokeMethod('openTWA', {"initUrl": initUrl + "?token=$fcmToken"});
    /// 아이폰
    } else {
      iosChannel.invokeMethod('find', {"initUrl": initUrl + "?token=$fcmToken"});
    }
  }

  /// 회원가입
  Future<void> register() async{
    var fcmToken = await FirebaseMessaging.instance.getToken();

    if(Platform.isAndroid) {
      final channel = MethodChannel('method_channel/twa');
      channel.invokeMethod('openTWA',{"initUrl" : MenuAPI.register.url + "?token=$fcmToken"});
    }else {
      iosChannel.invokeMethod('register', {"initUrl": MenuAPI.register.url + "?token=$fcmToken"});
    }
  }
}