package com.notii.cashnote;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import androidx.core.content.FileProvider;

import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.provider.MediaStore;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.Switch;
import android.widget.TextView;

import java.io.File;
import java.net.URISyntaxException;

import static android.Manifest.permission.CAMERA;
import static android.Manifest.permission.READ_EXTERNAL_STORAGE;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;

public class NativeWebView extends AppCompatActivity {

    private WebView webview;
    private WebSettings set;
    // 캐시노트 세팅
    private Context context;
    public ValueCallback<Uri> filePathCallbackNormal;
    public ValueCallback<Uri[]> filePathCallbackLollipop;
    public final static int FILECHOOSER_NORMAL_REQ_CODE = 2001;
    public final static int FILECHOOSER_LOLLIPOP_REQ_CODE = 2002;
    private Uri cameraImageUri = null;
    private WebView newWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native_web_view);

        context = this;
        webview = (WebView) findViewById(R.id.web_view_main);
        webview.setWebViewClient(new WishWebViewClient());
        webview.setOnKeyListener(webviewOnKey);
        webview.addJavascriptInterface(new aaa(), "Android");
        webview.setWebChromeClient(new WebChromeClient() {

            // For Android 5.0+ 카메라 - input type="file" 태그를 선택했을 때 반응
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            public boolean onShowFileChooser(
                    WebView webView, ValueCallback<Uri[]> filePathCallback,
                    FileChooserParams fileChooserParams) {
//                Log.d("MainActivity", "5.0+");

                if (filePathCallbackLollipop != null) {
                    filePathCallbackLollipop.onReceiveValue(null);
                    filePathCallbackLollipop = null;
                }
                filePathCallbackLollipop = filePathCallback;

                boolean isCapture = fileChooserParams.isCaptureEnabled();
                runCamera(isCapture);
                return true;
            }

            @Override
            public void onCloseWindow(WebView window) {
                Log.e("","close window1");
                super.onCloseWindow(window);
                Log.e("","close window2");
            }

            @Override
            public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
                // Dialog Create Code
                newWebView = new WebView(context);
                newWebView.getSettings().setJavaScriptEnabled(true);
                newWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
                newWebView.getSettings().setSupportMultipleWindows(true);
                newWebView.getSettings().setDomStorageEnabled(true);
                newWebView.getSettings().setAllowFileAccess(true);
                newWebView.getSettings().setAllowContentAccess(true);
                newWebView.getSettings().setAllowFileAccessFromFileURLs(true);
                newWebView.getSettings().setAllowUniversalAccessFromFileURLs(true);
                newWebView.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)); //making sure the popup opens full screen
                newWebView.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {

                        try {
                            if (url != null && url.startsWith("http") || url != null && url.startsWith("https")) {
                                view.loadUrl(url);
                            } else {

                                if (url.toLowerCase().startsWith("intent:")) {
                                    Intent parsedIntent = null;
                                    try {
                                        parsedIntent = Intent.parseUri(url, 0);
                                        startActivity(parsedIntent);
                                    } catch (ActivityNotFoundException | URISyntaxException e) {
                                    }
                                    return true;
                                } else {
                                    view.loadUrl(url);
                                }

                            }
                        } catch (Exception e) {
                        }
                        view.loadUrl(url);
                        return true;
                    }
                });
                newWebView.setWebChromeClient(new WebChromeClient() {
                    @Override
                    public void onCloseWindow(WebView window) {
                        super.onCloseWindow(window);

                        if (newWebView != null) {
                            webview.removeView(newWebView);
//                            newWebView = null;
                        }
                    }
                });
                WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;
                transport.setWebView(newWebView);
                resultMsg.sendToTarget();
                view.addView(newWebView);
                return true;

            }

        });

//        ActivityCompat.requestPermissions(this, new String[]{READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, CAMERA}, 0);

        set = webview.getSettings();
//        set.setCacheMode(WebSettings.LOAD_NO_CACHE);
        set.setRenderPriority(WebSettings.RenderPriority.HIGH);
        set.setJavaScriptEnabled(true);
        // 화면 비율
        set.setUseWideViewPort(true);
        set.setLoadWithOverviewMode(true); // 스크린 크기에 맞게 조절
        // 멀티 터치 확대
        set.setBuiltInZoomControls(true);
        set.setSupportZoom(true);
        set.setDisplayZoomControls(false);
        set.setDomStorageEnabled(true);
        set.setBlockNetworkImage(false);

        set.setSupportMultipleWindows(true);
        set.setJavaScriptCanOpenWindowsAutomatically(true);
        set.setAllowFileAccess(true);

//        set.setAllowContentAccess(true);
//        set.setAllowFileAccessFromFileURLs(true);
//        set.setAllowUniversalAccessFromFileURLs(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            set.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

//        String url = "https://dev.cashnote.tdi9.com/";
//        Log.e("","!!!!!!!!" + getIntent().getStringExtra("data"));
        Uri intent = getIntent().getData();
        webview.loadUrl(intent.toString());
    }

    // 카메라 기능 구현
    private void runCamera(boolean _isCapture) {
        Intent intentCamera = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        File path = getFilesDir();
        File file = new File(path, "sample.png"); // sample.png 는 카메라로 찍었을 때 저장될 파일명이므로 사용자 마음대로
        // File 객체의 URI 를 얻는다.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            String strpa = getApplicationContext().getPackageName();
            cameraImageUri = FileProvider.getUriForFile(this, strpa + ".fileprovider", file);
        } else {
            cameraImageUri = Uri.fromFile(file);
        }
        intentCamera.putExtra(MediaStore.EXTRA_OUTPUT, cameraImageUri);

        if (!_isCapture) { // 선택팝업 카메라, 갤러리 둘다 띄우고 싶을 때
            Intent pickIntent = new Intent(Intent.ACTION_PICK);
            pickIntent.setType(MediaStore.Images.Media.CONTENT_TYPE);
            pickIntent.setData(MediaStore.Images.Media.EXTERNAL_CONTENT_URI);

            String pickTitle = "사진 가져올 방법을 선택하세요.";
            Intent chooserIntent = Intent.createChooser(pickIntent, pickTitle);

            // 카메라 intent 포함시키기..
            chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Parcelable[]{intentCamera});
            startActivityForResult(chooserIntent, FILECHOOSER_LOLLIPOP_REQ_CODE);
        } else {// 바로 카메라 실행..
            startActivityForResult(intentCamera, FILECHOOSER_LOLLIPOP_REQ_CODE);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        switch (requestCode) {
            case FILECHOOSER_NORMAL_REQ_CODE:
                if (resultCode == RESULT_OK) {
                    if (filePathCallbackNormal == null) return;
                    Uri result = (data == null || resultCode != RESULT_OK) ? null : data.getData();
                    //  onReceiveValue 로 파일을 전송한다.
                    filePathCallbackNormal.onReceiveValue(result);
                    filePathCallbackNormal = null;
                }
                break;
            case FILECHOOSER_LOLLIPOP_REQ_CODE:
                if (resultCode == RESULT_OK) {
                    if (filePathCallbackLollipop == null) return;
                    if (data == null)
                        data = new Intent();
                    if (data.getData() == null)
                        data.setData(cameraImageUri);

                    filePathCallbackLollipop.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(resultCode, data));
                    filePathCallbackLollipop = null;
                } else {
                    if (filePathCallbackLollipop != null) {   //  resultCode에 RESULT_OK가 들어오지 않으면 null 처리하지 한다.(이렇게 하지 않으면 다음부터 input 태그를 클릭해도 반응하지 않음)
                        filePathCallbackLollipop.onReceiveValue(null);
                        filePathCallbackLollipop = null;
                    }

                    if (filePathCallbackNormal != null) {
                        filePathCallbackNormal.onReceiveValue(null);
                        filePathCallbackNormal = null;
                    }
                }
                break;
            default:

                break;
        }

        super.onActivityResult(requestCode, resultCode, data);
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    boolean checkBack = true;
    private View.OnKeyListener webviewOnKey = new View.OnKeyListener() {
        @Override
        public boolean onKey(View v, int keyCode, KeyEvent event) {

//            if (event.getAction() != KeyEvent.ACTION_DOWN)
//                return true;

            if (keyCode == KeyEvent.KEYCODE_BACK) {
                if (newWebView != null) {

                    if (newWebView.canGoBack()) {

                        newWebView.goBack();
                    } else {

                        newWebView.loadUrl("javascript:window.close();");
                    }
                }
//                if (mWebViewPop.canGoBack()) {
//                    log.e("canGoBack1");
//                    mWebViewPop.loadUrl("javascript:window.close();");
//                }
                else if (webview.canGoBack()) {

                    webview.goBack();
                } else {
                    if (checkBack) {
//                        AndroidUtility.showToast(NativeWebView.this, 0, "뒤로가기 버튼을 한번 더 누르시면 종료됩니다");
                        checkBack = false;
                        Handler mHandler_vertical = new Handler();
                        mHandler_vertical.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                checkBack = true;
                            }
                        }, 2000); // 2초안에 뒤로가기를 한번 더 누르지 않으면 종료되지 않고 문구 한번 더보임.
                    } else {
                        NativeWebView.this.finish();
//                        MainView.this.finish();
//                        moveTaskToBack(true);
//                        finish();
//                        android.os.Process.killProcess(android.os.Process.myPid());
                    }
                }
                return true;
            }
            return false;
        }
    };


    private class WishWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, final String url) {
            try {
                if (url != null && url.startsWith("http") || url != null && url.startsWith("https")) {

                    view.loadUrl(url);
                } else {

                    if (url.toLowerCase().startsWith("intent:")) {
                        Intent parsedIntent = null;
                        try {
                            parsedIntent = Intent.parseUri(url, 0);
                            startActivity(parsedIntent);
                        } catch (ActivityNotFoundException | URISyntaxException e) {
                        }
                        return true;
                    } else {
                        view.loadUrl(url);
                    }
                }
            } catch (Exception e) {

            }

            view.loadUrl(url);
            return true;
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
        }
    }

    Handler handler = new Handler();

    private final class aaa {
        @JavascriptInterface
        public void callClose(final String str) {
            Log.e("!!!!!!!!!str!!!!!!!! = ", str);
            handler.post(new Runnable() {
                @Override
                public void run() {
                    Log.e("", "!!!!!!!!!!!!!run!!!!!!!!!!!!!!");
                    finish();
                }
            });
        }
    }
}