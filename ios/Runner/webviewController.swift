//
//  ViewController.swift
//  webviews
//
//  Created by TDI MAC mini on 2022/01/25.
//

import UIKit
import WebKit

class webviewController: UIViewController , WKNavigationDelegate, WKScriptMessageHandler , WKUIDelegate, UIScrollViewDelegate {

    // MARK: [클래스 상속 설명]
    /*
    1. WKNavigationDelegate : 웹뷰 실시간 로드 상태 감지
    2. WKScriptMessageHandler : 자바스크립트 통신 사용
    3. WKUIDelegate : alert 팝업창 이벤트 감지
    */
    
    var popupWebView: WKWebView?
    
    var indicator : UIActivityIndicatorView!
    
    var initUrl : String? = "https://dev.cashnote.tdi9.com/m/login?token="
    
    
    // MARK: [액티비티 메모리 로드 수행 실시]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("")
        print("===============================")
        print("[ViewController >> viewDidLoad() : 액티비티 메모리 로드 실시]")
        print("===============================")
        print("")
        
        // [웹뷰 호출 실시]
        webviewInit(_loadUrl: initUrl!) // get 방식
        indicator = UIActivityIndicatorView()
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.mainWebView?.addSubview(indicator)
        indicator.startAnimating()
    }
    
    
    
    // MARK: [웹뷰 변수 선언 실시 = 스토리보드 없이 동적으로 생성]
    private var mainWebView: WKWebView? = nil
    // [ViewController 종료 시 호출되는 함수]
    deinit {
        // WKWebView Progress 퍼센트 가져오기 이벤트 제거
        self.mainWebView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    
    
    // MARK: [웹뷰 초기 설정 값 정의 실시 및 웹뷰 로드 수행]
    func webviewInit(_loadUrl:String){
        print("")
        print("===============================")
        print("[ViewController >> webviewInit() : 웹뷰 초기 설정 값 정의 실시 및 웹뷰 로드 수행]")
        print("url : \(_loadUrl)")
        print("===============================")
        print("")
        
        // [자바스크립트 통신 경로 지정 실시 : 모두 정의]
        self.addJavaScriptBridgeOpen()
        self.addJavaScriptBridgeClose()
        self.addJavaScriptBridgeTest()
        self.addJavaScriptLogout()
        
        
        // [웹뷰 전체 화면 설정 실시]
        // self.mainWebView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.mainWebView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), configuration: self.javascriptConfig)
        
        
        // [웹뷰 캐시 삭제 실시]
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler:{ })
        
        
        // [웹뷰 여백 및 배경 부분 색 투명하게 변경]
        //self.mainWebView?.backgroundColor = UIColor.clear
        //self.mainWebView?.isOpaque = false
        //self.mainWebView?.loadHTMLString("<body style=\"background-color: transparent\">", baseURL: nil)
        
        
        // [웹뷰 옵션값 지정]
        self.mainWebView?.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true  // 자바스크립트 활성화
        self.mainWebView?.navigationDelegate = self // 웹뷰 변경 상태 감지 위함
        self.mainWebView?.allowsBackForwardNavigationGestures = true // 웹뷰 뒤로가기, 앞으로 가기 제스처 사용
        self.mainWebView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) // 웹뷰 로드 상태 퍼센트 확인
        self.mainWebView?.uiDelegate = self // alert 팝업창 이벤트 받기 위함
        self.mainWebView?.scrollView.delegate = self
        self.mainWebView?.insetsLayoutMarginsFromSafeArea = true
        
        // safeArea 관련 설정
        self.mainWebView?.scrollView.contentInsetAdjustmentBehavior = .never

        
        // [입력창 자동 줌 방지 스크립트]
        self.mainWebView?.configuration.userContentController.addUserScript(self.getZoomDisableScript())
        
        // [웹뷰 화면 비율 설정 및 초기 웹뷰 로드 실시 : get url 주소]
        self.view.addSubview(self.mainWebView!)
        let url = URL (string: _loadUrl) // 웹뷰 로드 주소
        let request = URLRequest(url: url! as URL)
        self.mainWebView!.load(request)
        
    }
    
    // safeArea 관련 설정
    override func viewSafeAreaInsetsDidChange()
    {
        if #available(iOS 11.0, *)
        {
            self.mainWebView!.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":self.mainWebView!]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(self.view.safeAreaInsets.top))-[v0]-(\(self.view.safeAreaInsets.bottom))-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":self.mainWebView!]))
            
        }
        
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    // disable zoom
    
    private func getZoomDisableScript() ->WKUserScript{
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    
    
    // MARK: [자바스크립트 통신을 위한 초기화 부분]
    let javascriptController = WKUserContentController()
    let javascriptConfig = WKWebViewConfiguration()
    func addJavaScriptBridgeOpen(){
        print("")
        print("===============================")
        print("[ViewController >> addJavaScriptBridgeOpen() : 자바스크립트 통신 브릿지 추가]")
        print("Bridge : open")
        print("===============================")
        print("")
        
        // [open 브릿지 경로 추가]
        self.javascriptController.add(self, name: "open")
        self.javascriptConfig.userContentController = self.javascriptController
        //self.mainWebView = WKWebView(frame: self.view.bounds, configuration: javascriptConfig)
    }
    func addJavaScriptBridgeClose(){
        print("")
        print("===============================")
        print("[ViewController >> addJavaScriptBridgeClose() : 자바스크립트 통신 브릿지 추가]")
        print("Bridge : close")
        print("===============================")
        print("")
        // [close 브릿지 경로 추가]
        self.javascriptController.add(self, name: "close")
        self.javascriptConfig.userContentController = self.javascriptController
        //self.mainWebView = WKWebView(frame: self.view.bounds, configuration: javascriptConfig)
    }
    func addJavaScriptBridgeTest(){
        print("")
        print("===============================")
        print("[ViewController >> addJavaScriptBridgeTest() : 자바스크립트 통신 브릿지 추가]")
        print("Bridge : test")
        print("===============================")
        print("")
        // [test 브릿지 경로 추가]
        self.javascriptController.add(self, name: "test")
        self.javascriptConfig.userContentController = self.javascriptController
        //self.mainWebView = WKWebView(frame: self.view.bounds, configuration: javascriptConfig)
    }
    func addJavaScriptLogout()
    {
        self.javascriptController.add(self, name: "logout")
        self.javascriptConfig.userContentController = self.javascriptController
    }
    
    
    
    // MARK: [자바스크립트 >> IOS 통신 부분]
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // MARK: [웹 코드] window.webkit.messageHandlers.open.postMessage("[open] 자바스크립트 >> IOS 호출");
            
        if message.name == "logout"
        {
            let receiveData = message.body
            print("logout 호출 옴")
            print("receiveData : ", receiveData)
            self.mainWebView = nil
            self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: [IOS >> 자바스크립트 통신 부분]
    func sendFunctionOpen(_send:String){
        print("")
        print("===============================")
        print("[ViewController >> sendFunctionOpen() : IOS >> 자바스크립트]")
        print("_send : ", _send)
        print("===============================")
        print("")
        self.mainWebView!.evaluateJavaScript("receive_Open('\(_send)')", completionHandler: nil)
        /*self.mainWebView!.evaluateJavaScript("receive_Open('')", completionHandler: {
            (any, err) -> Void in
            print(err ?? "[receive_Open] IOS >> 자바스크립트 : SUCCESS")
        })*/
    }
    func sendFunctionClose(_send:String){
        print("")
        print("===============================")
        print("[ViewController >> sendFunctionClose() : IOS >> 자바스크립트]")
        print("_send : ", _send)
        print("===============================")
        print("")
        self.mainWebView!.evaluateJavaScript("receive_Close('\(_send)')", completionHandler: nil)
        /*self.mainWebView!.evaluateJavaScript("receive_Close('')", completionHandler: {
            (any, err) -> Void in
            print(err ?? "[receive_Close] IOS >> 자바스크립트 : SUCCESS")
        })*/
    }
    func sendFunctionTest(_send:String){
        print("")
        print("===============================")
        print("[ViewController >> sendFunctionClose() : IOS >> 자바스크립트]")
        print("_send : ", _send)
        print("===============================")
        print("")
        self.mainWebView!.evaluateJavaScript("receive_Test('\(_send)')", completionHandler: nil)
        /*self.mainWebView!.evaluateJavaScript("receive_Test('')", completionHandler: {
            (any, err) -> Void in
            print(err ?? "[receive_Test] IOS >> 자바스크립트 : SUCCESS")
        })*/
    }
    
    
    // [웹뷰 로드 수행 시작 부분]
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        let _startUrl = String(describing: webView.url?.description ?? "")
        print("")
        print("===============================")
        print("[ViewController >> didStartProvisionalNavigation() : 웹뷰 로드 수행 시작]")
        print("url : \(_startUrl)")
        print("===============================")
        print("")
    }
    
    
    // [웹뷰 로드 상태 퍼센트 확인 부분]
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 0 ~ 1 사이의 실수형으로 결과값이 출력된다 [0 : 로딩 시작, 1 : 로딩 완료]
        print("")
        print("===============================")
        print("[ViewController >> observeValue() : 웹뷰 로드 상태 확인]")
        print("loading : \(Float((self.mainWebView?.estimatedProgress)!)*100)")
        print("===============================")
        print("")
    }
    
    
    // [웹뷰 로드 수행 완료 부분]
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        let _endUrl = String(describing: webView.url?.description ?? "")
        print("")
        print("===============================")
        print("[ViewController >> didFinish() : 웹뷰 로드 수행 완료]")
        print("url : \(_endUrl)")
        print("===============================")
        print("\(String(describing: webView.url))")
    }

    
    // [웹뷰 로드 수행 에러 확인]
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let _nsError = error as NSError
        let _errorUrl = String(describing: webView.url?.description ?? "")
        print("")
        print("===============================")
        print("[ViewController >> didFail() : 웹뷰 로드 수행 에러]")
        print("_errorUrl : \(_errorUrl)")
        print("_errorCode : \(_nsError)")
        print("_errorMsg : \(S_WebViewErrorCode().checkError(_errorCode: 1019))")
        print("===============================")
        print("")
    }

    
    // [웹뷰 실시간 url 변경 감지 실시]
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let request = navigationAction.request
            let optUrl = request.url
            let optUrlScheme = optUrl?.scheme

            guard let url = optUrl, let scheme = optUrlScheme
                else {
                    return decisionHandler(WKNavigationActionPolicy.cancel)
            }

            debugPrint("url : \(url)")

            if( scheme != "http" && scheme != "https" ) {
                
                    if( UIApplication.shared.canOpenURL(url) ) {
                        UIApplication.shared.open(url,options: [:],completionHandler: nil)
                    } else {
                        //1. App 미설치 확인
                        //2. info.plist 내 scheme 등록 확인
                    }
                }
        decisionHandler(WKNavigationActionPolicy.allow)

        guard let url = navigationAction.request.url else { return }
        print("")
        print("===============================")
        print("[ViewController >> decidePolicyFor() : 웹뷰 실시간 url 변경 감지]")
        print("requestUrl : \(url)")
        print("===============================")
        print("")
    }
    
    
    // [웹뷰 모달창 닫힐때 앱 종료현상 방지]
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        
    // [alert 팝업창 처리]
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        print("")
        print("===============================")
        print("[ViewController >> runJavaScriptAlertPanelWithMessage() : alert 팝업창 처리]")
        print("message : ", message)
        print("===============================")
        print("")
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
        self.present(alertController, animated: true, completion: nil)
    }
    


    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)

        popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        popupWebView?.navigationDelegate = self
        

        popupWebView?.uiDelegate = self

        view.addSubview(popupWebView!)

        return popupWebView!

    }
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil

     }

     
    // [confirm 팝업창 처리]
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("")
        print("===============================")
        print("[ViewController >> runJavaScriptConfirmPanelWithMessage() : confirm 팝업창 처리]")
        print("message : ", message)
        print("===============================")
        print("")
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false) }))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true) }))
        self.present(alertController, animated: true, completion: nil)
    }
    

    // [href="_blank" 링크 이동 처리]
    /*func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("")
        print("===============================")
        print("[ViewController >> createWebViewWith() : href=_blank 링크 이동]")
        print("===============================")
        print("")
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }*/
    
}
