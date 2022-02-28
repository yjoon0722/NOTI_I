package com.notii.cashnote;

import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.MimeTypeMap;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;

import java.io.File;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.Date;

import io.flutter.embedding.android.FlutterActivity;

public class NativeWebView2 extends AppCompatActivity {

    public ValueCallback<Uri[]> filePathCallback;
    public final static int FILECHOOSER_REQ_CODE = 2002;
    private Uri cameraImageUri = null;

    private Context mContext;

    private WebView mWebView;
    private WebView mNewWebView;
    private WebSettings mWebSettings;

    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyyMMdd-HHmmss");

    private Dialog dialog;

    private ProgressBar pBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native_web_view);

        pBar = findViewById(R.id.pBar); // 로딩바
        pBar.setBackgroundColor(Color.WHITE);
        pBar.setVisibility(View.GONE); // 로딩바 가리기 (로딩때만 보여야 함)

        mContext = this;
        mWebView = findViewById(R.id.web_view_main);
        mWebView.setWebViewClient(new MyWebViewClient());
        mWebView.addJavascriptInterface(new NativeWebView2.WebViewInterface(), "Android");
        ///
//        final ProgressBar progressBar = new ProgressBar(getBaseContext(), null, android.R.attr.progressBarStyle);
//        progressBar.setMax(100);
//        progressBar.setVisibility(View.GONE);
//
//        mWebView.setWebChromeClient(null);
//        mWebView.setWebChromeClient(new WebChromeClient() {
//            @Override
//            public void onProgressChanged (WebView view,int newProgress){
//                super.onProgressChanged(view, newProgress);
//                progressBar.setVisibility(View.VISIBLE);
//
//                if (newProgress == 100) {
//                    progressBar.setVisibility(View.GONE);
//                } else {
//                    progressBar.setProgress(newProgress);
//                }
//            }
//        });
        ///
//        mWebView.setBackgroundColor(0);
//        mWebView.getProgress();
        mWebView.setWebChromeClient(new WebChromeClient() {

            @Override
            public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {

                // Callback 초기화
                if (NativeWebView2.this.filePathCallback != null) {
                    NativeWebView2.this.filePathCallback.onReceiveValue(null);
                    NativeWebView2.this.filePathCallback = null;
                }
                NativeWebView2.this.filePathCallback = filePathCallback;
                runFileChooser();

                return true;
            }

            @Override
            public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
                // Dialog Create Code
                mNewWebView = new WebView(mContext);
                mNewWebView.getSettings().setJavaScriptEnabled(true);
                mNewWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
                mNewWebView.getSettings().setSupportMultipleWindows(true);
                mNewWebView.getSettings().setDomStorageEnabled(true);
                mNewWebView.getSettings().setAllowFileAccess(true);
                mNewWebView.getSettings().setAllowContentAccess(true);
                mNewWebView.getSettings().setAllowFileAccessFromFileURLs(true);
                mNewWebView.getSettings().setAllowUniversalAccessFromFileURLs(true);
//                mNewWebView.setLayoutParams(new ConstraintLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)); //making sure the popup opens full screen
//                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
//                lp.width = WindowManager.LayoutParams.MATCH_PARENT;
//                lp.height = WindowManager.LayoutParams.MATCH_PARENT;
//                mNewWebView.setLayoutParams(lp);
//                mWebview.scrollTo(0,0);
                dialog = new Dialog(mContext);
                dialog.setContentView(mNewWebView);

                ViewGroup.LayoutParams params = dialog.getWindow().getAttributes();
                params.width = ViewGroup.LayoutParams.MATCH_PARENT;
                params.height = ViewGroup.LayoutParams.MATCH_PARENT;
                dialog.getWindow().setAttributes((android.view.WindowManager.LayoutParams) params);
                dialog.show();
                dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                    @Override
                    public void onDismiss(DialogInterface dialogInterface) {
                        if (mNewWebView != null) {
                            if (mNewWebView.canGoBack()) {
                                Log.e("TAG","canGoBack");
                                mNewWebView.goBack();
                            } else {
                                Log.e("TAG","javascript:window.close();");
                                mNewWebView.loadUrl("javascript:window.close();");
                            }
                            return;
                        }
                    }
                });
                mNewWebView.setWebViewClient(new MyWebViewClient());
                mNewWebView.setWebChromeClient(new WebChromeClient() {
                    @Override
                    public void onCloseWindow(WebView window) {
                        Log.e("TAG","ClosedWindow");
                        if (mNewWebView != null) {
                            mWebView.removeView(mNewWebView);
                            mNewWebView.destroy();
                            mNewWebView = null;
                            dialog.dismiss();
                        }
                        super.onCloseWindow(window);
                    }



                });
                WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;
                transport.setWebView(mNewWebView);
                resultMsg.sendToTarget();
//                view.addView(mNewWebView);
                return true;

            }

        });

        mWebSettings = mWebView.getSettings();
//        set.setCacheMode(WebSettings.LOAD_NO_CACHE);
        mWebSettings.setRenderPriority(WebSettings.RenderPriority.HIGH);
        mWebSettings.setJavaScriptEnabled(true);
        // 화면 비율
        mWebSettings.setUseWideViewPort(true);
        mWebSettings.setLoadWithOverviewMode(true); // 스크린 크기에 맞게 조절
        // 멀티 터치 확대
//        set.setBuiltInZoomControls(true);
//        set.setSupportZoom(true);
//        set.setDisplayZoomControls(false);
        mWebSettings.setDomStorageEnabled(true);
        mWebSettings.setBlockNetworkImage(false);

        mWebSettings.setSupportMultipleWindows(true);
        mWebSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        mWebSettings.setAllowFileAccess(true);

        mWebSettings.setAllowContentAccess(true);
        mWebSettings.setAllowFileAccessFromFileURLs(true);
        mWebSettings.setAllowUniversalAccessFromFileURLs(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mWebSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        Uri intent = getIntent().getData();
        mWebView.loadUrl(intent.toString());
    }

    private void runFileChooser() {
        Intent intentCamera = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        File path = mContext.getFilesDir();
        File file = new File(path, "Temp_" + mSimpleDateFormat.format(new Date()) + ".jpg");

        cameraImageUri = Uri.fromFile(file);
        intentCamera.putExtra(MediaStore.EXTRA_OUTPUT, FileProvider.getUriForFile(mContext, getPackageName() + ".fileprovider", file));

        Intent pickIntent = new Intent(Intent.ACTION_PICK);

//        pickIntent.setType(MediaStore.Images.Media.CONTENT_TYPE);
//        pickIntent.setData(MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        pickIntent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,MediaStore.Images.Media.CONTENT_TYPE);
        Log.e("!!!: ","pickIntent.getType = " + pickIntent.getType());

        String pickTitle = "이미지 파일 등록";
        Intent chooserIntent = Intent.createChooser(pickIntent, pickTitle);

        // 카메라 intent 포함시키기..
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Parcelable[]{intentCamera});
        startActivityForResult(chooserIntent, FILECHOOSER_REQ_CODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        switch (requestCode) {
            case FILECHOOSER_REQ_CODE:
                if (resultCode == RESULT_OK) {
                    if (filePathCallback == null) return;
                    if (data == null)
                        data = new Intent();
                    if (data.getData() == null) {
                        data.setDataAndType(cameraImageUri,"image/*");
//                        data.setData(cameraImageUri);
                        Log.e("!!! : ", "data.getType() = " + data.getType());
                    }

                    filePathCallback.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(resultCode, data));
                    filePathCallback = null;
                } else {
                    if (filePathCallback != null) {   //  resultCode에 RESULT_OK가 들어오지 않으면 null 처리하지 한다.(이렇게 하지 않으면 다음부터 input 태그를 클릭해도 반응하지 않음)
                        filePathCallback.onReceiveValue(null);
                        filePathCallback = null;
                    }
                }
                break;
            default:

                break;
        }

        super.onActivityResult(requestCode, resultCode, data);
    }


    boolean checkBack = false;
    @Override
    public void onBackPressed() {
        Log.e("TAG","OnBackPressed");
        if (mNewWebView != null) {
            if (mNewWebView.canGoBack()) {
                Log.e("TAG","canGoBack");
                mNewWebView.goBack();
            } else {
                Log.e("TAG","javascript:window.close();");
                mNewWebView.loadUrl("javascript:window.close();");
            }
            return;
        } else if (mWebView != null && mWebView.canGoBack()) {
            mWebView.goBack();
        } else {
            if(mWebView != null &&
                    (mWebView.getUrl().contains("https://front.cashnote.notii.net/m/register")
                    || mWebView.getUrl().contains("https://front.cashnote.notii.net/m/help/id")
                    || mWebView.getUrl().contains("https://front.cashnote.notii.net/m/help/pw"))) {
                super.onBackPressed();
                return;
            }
            if (checkBack) {
                super.onBackPressed();
                finish();
                return;
            }

            checkBack = true;
            Toast.makeText(this, "뒤로가기 버튼을 한번 더 누르시면 종료됩니다", Toast.LENGTH_SHORT).show();

            new Handler().postDelayed(new Runnable() {

                @Override
                public void run() {
                    checkBack = false;
                }
            }, 2000);
        }
    }

    private class MyWebViewClient extends WebViewClient {

        @Override                                   // 1) 로딩 시작
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
            pBar.setVisibility(View.VISIBLE);       // 로딩이 시작되면 로딩바 보이기
        }

        @Override                                   // 2) 로딩 끝
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            pBar.setVisibility(View.GONE);          // 로딩이 끝나면 로딩바 없애기
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, final String url) {

            if (url != null && url.startsWith("intent://")) {
                try {
                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                    Intent existPackage = getPackageManager().getLaunchIntentForPackage(intent.getPackage());
                    if (existPackage != null) {
                        startActivity(intent);
                    } else {
                        Intent marketIntent = new Intent(Intent.ACTION_VIEW);
                        marketIntent.setData(Uri.parse("market://details?id=" + intent.getPackage()));
                        startActivity(marketIntent);
                    }
                    return true;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (url != null && url.startsWith("market://")) {
                try {
                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                    if (intent != null) {
                        startActivity(intent);
                    }
                    return true;
                } catch (URISyntaxException e) {
                    e.printStackTrace();
                }
            } else if (url != null && (url.startsWith("http") || url != null && url.startsWith("https"))) {
                view.loadUrl(url);
                return true;
            }
            return false;

        }
    }

    private final class WebViewInterface {
        @JavascriptInterface
        public void callClose(final String str) {
            Log.e("TAG","callClose");
            if (str.equals("close")) {
                finish();
                Intent intent = new Intent(mContext, MainActivity.class);
                startActivity(intent);
            }
        }
    }
}