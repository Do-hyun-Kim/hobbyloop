//
//  AccountRouter.swift
//  HPNetwork
//
//  Created by Kim dohyun on 2023/06/02.
//

import Foundation

import Alamofire
import HPCommon

public enum AccountRouter {
    case getNaverUserInfo
    case getAccessToken
}



extension AccountRouter: Router {
    
    public var baseURL: String {
        switch self {
        case .getNaverUserInfo:
            return "https://openapi.naver.com"
        case .getAccessToken:
            return "http://13.125.114.152:8080"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .getNaverUserInfo:
            return .get
        case .getAccessToken:
            return .get
        }
    }
    
    public var path: String {
        switch self {
        case .getNaverUserInfo:
            return "/v1/nid/me"
        case .getAccessToken:
            return "/login/oauth2/kakao"
        }
        
    }
    
    public var headers: HTTPHeaders {
        // TODO: HTTPHeaders 값을 Custom으로 구현하여 AccessToken 값 만료 됬을때는 default로 호출되도록 하기
        var decryption = ""
        guard !UserDefaults.standard.string(forKey: .accessToken).isEmpty else { return .default }
        do {
            decryption = try CryptoUtil.makeDecryption(UserDefaults.standard.string(forKey: .accessToken))
        } catch {
            print(error.localizedDescription)
        }
        return ["Authorization":"bearer \(decryption)"]
    }
    
    
    
    
}
