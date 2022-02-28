import UIKit
import Flutter
//import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var navigationController : UINavigationController!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller = self.window?.rootViewController as! FlutterViewController
      linkNativeCode(controller: controller)
//      if #available(iOS 14, *) {
//                  let time = DispatchTime.now() + .seconds(4)
//                  DispatchQueue.main.asyncAfter(deadline: time) {
//                      self.requestPermission()
//                  }
//              }
      GeneratedPluginRegistrant.register(with: self)
      
      self.navigationController = UINavigationController(rootViewController: controller)
      self.window?.rootViewController = self.navigationController
      self.navigationController.setNavigationBarHidden(true, animated: true)
      self.window?.makeKeyAndVisible()
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//    func requestPermission() {
//             if #available(iOS 14, *) {
//                  ATTrackingManager.requestTrackingAuthorization { status in
//                      switch status {
//                      case .authorized:
//                          // Tracking authorization dialog was shown
//                          // and we are authorized
//                          print("Authorized")
//                          // Now that we are authorized we can get the IDFA
//    //                    print(ASIdentifierManager.shared().advertisingIdentifier)
//
//                      case .denied:
//                         // Tracking authorization dialog was
//                         // shown and permission is denied
//                           print("Denied")
//                      case .notDetermined:
//                              // Tracking authorization dialog has not been shown
//                              print("Not Determined")
//                      case .restricted:
//                              print("Restricted")
//                      @unknown default:
//                              print("Unknown")
//
//                      }
//                  }
//             }
//        }
}

extension AppDelegate{
    
    func linkNativeCode(controller: FlutterViewController)
    {
        setupMethodChannel(controller: controller)
    }
    
    private func setupMethodChannel(controller: FlutterViewController)
    {
        let channel = FlutterMethodChannel(name:"loginHelper", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler(
            {
                (call: FlutterMethodCall, result: @escaping FlutterResult) ->Void in
                // 로그인 버튼 클릭시 처리
                if call.method == "login"
                {
                    let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "viewpage") as! webviewController
                    if let arguments = call.arguments as? Dictionary<String,Any>,
                       let url = arguments["initUrl"] as? String
                    {
                        vc.initUrl = url
                    }
                    self.navigationController.pushViewController(vc, animated: true)
                }
                // 회원가입 버튼 클릭시 처리
                else if call.method == "register"
                {
                    let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "viewpage") as! webviewController
                    if let arguments = call.arguments as? Dictionary<String,Any>,
                       let url = arguments["initUrl"] as? String
                    {
                        vc.initUrl = url
                    }
                    self.navigationController.pushViewController(vc, animated: true)
                }
                else if call.method == "find"
                {
                    let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "viewpage") as! webviewController
                    if let arguments = call.arguments as? Dictionary<String,Any>,
                       let url = arguments["initUrl"] as? String
                    {
                        vc.initUrl = url
                    }
                    self.navigationController.pushViewController(vc, animated: true)
                }
            })

    }
    
    
}
