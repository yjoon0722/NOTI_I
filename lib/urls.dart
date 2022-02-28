class Urls {
  /// BASE URI,
  // static String DEV_BASE_URI = "https://dev.partner-api.notii.tdi9.com/api/v1";
  static String BASE_API_URI = "https://api.cashnote.notii.net/api/v1";

  /// 메뉴 BASE URI. MenuAPI 와 연결
  // static String BASE_MENU_URI = "https://dev.cashnote.tdi9.com";
  static String BASE_MENU_URI = "https://front.cashnote.notii.net";
}

enum CashNoteAPI {
  /// 로그인
  login,

  /// 회원가입
  register,

  /// FCM 토큰 등록
  fcm,

  /// 토큰 상태 확인
  session
}

extension CashNoteAPIExtension on CashNoteAPI {
  String get endpoint {
    switch(this) {
      case CashNoteAPI.login:
        return '/login';
      case CashNoteAPI.register :
        return '/register';
      case CashNoteAPI.fcm :
        return '/save-token';
      case CashNoteAPI.session:
        return '/session';
    }
  }

  String get url {
    return Urls.BASE_API_URI + endpoint;
  }
}

// enum Partner {
//   /// 로그인
//   login,
//
//   /// 회원가입
//   register,
//
//   ///청구서 자세히 보기, 요청 뒤에 청구서 번호 등록 필요
//   receipt,
//
//   /// 공지사항
//   notices,
//
//   /// 충전내역 조회내역, 요청 뒤 월 입력 필요  ex)?month="202201"
//   orders,
//
//   /// 광고 등록
//   campaign,
// }
//
// extension PartnerExtension on Partner {
//   String get endpoint {
//     switch (this) {
//       case Partner.login:
//         return '/partner/login';
//       case Partner.register:
//         return '/partner/register';
//       case Partner.receipt:
//         return '/c/u/point/order/receipt/';
//       case Partner.notices:
//         return '/c/u/notices';
//       case Partner.orders:
//         return '/c/u/point/orders';
//       case Partner.campaign:
//         return '/cash-note/campaign';
//     }
//   }
//
//   String get url {
//     return Urls.DEV_BASE_URI + endpoint;
//   }
// }

enum MenuAPI {
  ///로그인 브릿지, 바로 뒤에 token 값 넣어줘야 함
  login,

  /// 회원가입
  register,

  /// 아이디찾기
  findID,

  /// 비밀번호찾기
  findPW,

  ///로그아웃 브릿지
  logout,

  /// 광고
  campaign,

  /// 리포트
  report,

  /// 내역
  history,

  /// 설정
  support,

  /// 회원정보
  mypage,

  /// 공지사항
  notice,

  /// 자주하는 질문
  faq,

  /// 1:1 문의
  inquiry,

  /// 충전
  charge
}

extension MenuAPIExtension on MenuAPI {
  String get endpoint {
    switch (this) {
      case MenuAPI.login:
        return '/m/login';

      case MenuAPI.register:
        return '/m/register';

      case MenuAPI.findID:
        return '/m/help/id';

      case MenuAPI.findPW:
        return '/m/help/pw';

      case MenuAPI.logout:
        return '/m/logout';

      case MenuAPI.campaign:
        return '/campaign';

      case MenuAPI.report:
        return '/report';

      case MenuAPI.history:
        return '/history';

      case MenuAPI.support:
        return '/support';

      case MenuAPI.mypage:
        return '/support/mypage';

      case MenuAPI.notice:
        return '/support/notice';

      case MenuAPI.faq:
        return '/support/faq';

      case MenuAPI.inquiry:
        return '/support/inquiry';

      case MenuAPI.charge:
        return '/support/charge';
    }
  }

  String get url {
    return Urls.BASE_MENU_URI + endpoint;
  }
}
