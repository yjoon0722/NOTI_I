import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashnote/constants.dart';
import 'package:cashnote/controller/login_controller.dart';
import 'package:cashnote/urls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends GetView<LoginController> {

  @override
  Widget build(BuildContext context) {
    return Obx((){
      /// 키보드가 올라와 있을 때 빈 화면 터치 시 키보드 내려감
      return GestureDetector(
        onTap: (){
          controller.focusNode.unfocus();
        },
        child: FocusScope(
          node: controller.focusNode,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                color: const Color(0xfff5f5f5),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 720.h - MediaQuery.of(context).padding.top
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 120.h),
                        Container(
                          width: 360.w,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Constants.NOTI_I_LOGO,
                            height: 34.h,
                          ),
                        ),
                        SizedBox(height: 50.h),
                        inputTextField("아이디",false,controller.idController!),
                        SizedBox(height: 20.h),
                        inputTextField("비밀번호",true,controller.pwController!),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            findButton("아이디",MenuAPI.findID.url),
                            SizedBox(width: 20.w),
                            Container(
                              width: 1.w,
                              height: 12.h,
                              color: const Color(0xffe1e1e1),
                            ),
                            SizedBox(width: 19.w),
                            findButton("비밀번호",MenuAPI.findPW.url)
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: GestureDetector(
                            onTap: () => controller.register(),
                            child: Container(
                              width: 328.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                  color: const Color(0xffececec),
                                  borderRadius: BorderRadius.all(Radius.circular(6.r))
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "회원가입",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: Constants.SpoqaHanSansNeoBold,
                                    letterSpacing: -0.28.sp,
                                    color: const Color(0xff1c1c1c)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: GestureDetector(
                            onTap: () async {
                                await controller.login(context);
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
                                "로그인",
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
              ),
            ),
          ),
        ),
      );
    });
  }

  // TextField
  Widget inputTextField(String title,bool isPwd,TextEditingController textEditingController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: Constants.SpoqaHanSansNeoBold,
              letterSpacing: -0.28.sp
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                  color: const Color(0xffe1e1e1)
              )
          ),
          child: TextField(
            controller: textEditingController,
            obscureText: isPwd ? controller.isObscure.value : false,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "$title를 입력해주세요.",
                hintStyle: TextStyle(
                  color: const Color(0xffc6c6c6),
                  fontSize: 14.sp,
                  fontFamily: Constants.SpoqaHanSansNeoRegular,
                  letterSpacing: -0.28.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 16.w),
                suffixIcon: SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: isPwd ? IconButton(
                    onPressed: () => controller.changeIsObscure(),
                    // icon: const Icon(Icons.remove_red_eye),
                    icon: Image.asset(
                      Constants.IMG_PATH + "pwd.png",
                      width: 20.w,
                    ),
                  ) : null,
                )
            ),
          ),
        ),
      ],
    );
  }

  // 찾기 버튼
  Widget findButton(String title, String initUrl) {
    return GestureDetector(
        onTap: (){ controller.find(initUrl); },
        child: Text(
          "$title찾기",
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: Constants.SpoqaHanSansNeoMedium,
            letterSpacing: -0.28.sp,
            color: const Color(0xff1c1c1c)
          ),
        )
    );
  }
}
