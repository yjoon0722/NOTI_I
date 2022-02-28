//
//  S_WebViewErrorCode.swift
//  웹뷰 에러 코드 관리
//

import Foundation

class S_WebViewErrorCode {
    
    
    /*
    [클래스 설명]
    1. 웹뷰 호출 시 발생하는 에러 코드 관리 클래스
    2. 사용 방법 : S_WebViewErrorCode().checkError(_errorCode: 1019)
    */
    
    func checkError(_errorCode:Int) -> String {
        // ========== [일반 에러 정의] ==========
        if _errorCode == NSURLErrorCancelled {
            return "NSURLErrorCancelled [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorUnknown{
            return "NSURLErrorUnknown [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorBadURL{
            return "NSURLErrorBadURL [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorTimedOut{
            return "NSURLErrorTimedOut [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorUnsupportedURL{
            return "NSURLErrorUnsupportedURL [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotFindHost{
            return "NSURLErrorCannotFindHost [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotConnectToHost{
            return "NSURLErrorCannotConnectToHost [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorNetworkConnectionLost{
            return "NSURLErrorNetworkConnectionLost [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorDNSLookupFailed{
            return "NSURLErrorDNSLookupFailed [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorHTTPTooManyRedirects{
            return "NSURLErrorHTTPTooManyRedirects [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorResourceUnavailable{
            return "NSURLErrorResourceUnavailable [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorNotConnectedToInternet{
            return "NSURLErrorNotConnectedToInternet [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorRedirectToNonExistentLocation{
            return "NSURLErrorRedirectToNonExistentLocation [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorBadServerResponse{
            return "NSURLErrorBadServerResponse [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorUserCancelledAuthentication{
            return "NSURLErrorUserCancelledAuthentication [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorUserAuthenticationRequired{
            return "NSURLErrorUserAuthenticationRequired [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorZeroByteResource{
            return "NSURLErrorZeroByteResource [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotDecodeRawData{
            return "NSURLErrorCannotDecodeRawData [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotDecodeContentData{
            return "NSURLErrorCannotDecodeContentData [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotParseResponse{
            return "NSURLErrorCannotParseResponse [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorAppTransportSecurityRequiresSecureConnection{
            return "NSURLErrorAppTransportSecurityRequiresSecureConnection [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorFileDoesNotExist{
            return "NSURLErrorFileDoesNotExist [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorFileIsDirectory{
            return "NSURLErrorFileIsDirectory [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorNoPermissionsToReadFile{
            return "NSURLErrorNoPermissionsToReadFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorDataLengthExceedsMaximum{
            return "NSURLErrorDataLengthExceedsMaximum [ \(String(_errorCode)) ]"
        }
        
        
        
        // ========== [ssl 에러 발생] ==========
        else if _errorCode == NSURLErrorSecureConnectionFailed{
            return "NSURLErrorSecureConnectionFailed [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorServerCertificateHasBadDate{
            return "NSURLErrorServerCertificateHasBadDate [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorServerCertificateUntrusted{
            return "NSURLErrorServerCertificateUntrusted [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorServerCertificateHasUnknownRoot{
            return "NSURLErrorServerCertificateHasUnknownRoot [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorServerCertificateNotYetValid{
            return "NSURLErrorServerCertificateNotYetValid [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorClientCertificateRejected{
            return "NSURLErrorClientCertificateRejected [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorClientCertificateRequired{
            return "NSURLErrorClientCertificateRequired [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotLoadFromNetwork{
            return "NSURLErrorCannotLoadFromNetwork [ \(String(_errorCode)) ]"
        }
        
        
        
        // ========== [파일 관련 에러] ==========
        else if _errorCode == NSURLErrorCannotCreateFile{
            return "NSURLErrorCannotCreateFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotOpenFile{
            return "NSURLErrorCannotOpenFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotCloseFile{
            return "NSURLErrorCannotCloseFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotWriteToFile{
            return "NSURLErrorCannotWriteToFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotRemoveFile{
            return "NSURLErrorCannotRemoveFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCannotMoveFile{
            return "NSURLErrorCannotMoveFile [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorDownloadDecodingFailedMidStream{
            return "NSURLErrorDownloadDecodingFailedMidStream [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorDownloadDecodingFailedToComplete{
            return "NSURLErrorDownloadDecodingFailedToComplete [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorInternationalRoamingOff{
            return "NSURLErrorInternationalRoamingOff [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorCallIsActive{
            return "NSURLErrorCallIsActive [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorDataNotAllowed{
            return "NSURLErrorDataNotAllowed [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorRequestBodyStreamExhausted{
            return "NSURLErrorRequestBodyStreamExhausted [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorBackgroundSessionRequiresSharedContainer{
            return "NSURLErrorBackgroundSessionRequiresSharedContainer [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorBackgroundSessionInUseByAnotherProcess{
            return "NSURLErrorBackgroundSessionInUseByAnotherProcess [ \(String(_errorCode)) ]"
        }
        else if _errorCode == NSURLErrorBackgroundSessionWasDisconnected{
            return "NSURLErrorBackgroundSessionWasDisconnected [ \(String(_errorCode)) ]"
        }
        
        
        
        // ========== [else 처리] ==========
        else {
            return "else [ \(String(_errorCode)) ]"
        }
    }
}
