//
//  NetworkRequestRetrier.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 19/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation
import Alamofire


class NetworkRequestRetrier : RequestRetrier {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ tokenResponse: LoginResponse?) -> Void
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, tokenResponse in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock()}
                    if succeeded, let tokenResponse = tokenResponse {
                        KeyChainManager.saveTokenResponse(accessToken: tokenResponse.access_token!, refreshToken: tokenResponse.refresh_token!)
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0)}
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
        
    }
    
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        let urlString = ApiURl.ApiParameterKey.refreshTokenURL
        
        let params: [String: Any] = [
            "refresh_token": KeyChainManager.getRefreshToken()!,
        ]
        
        let headers : HTTPHeaders = [
            "Content-Type" : "application/json",
            "platform": "mobile"
        ]
        _ = Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .debugLog()
            .validate(statusCode: 200..<300)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                switch response.result {
                    case .success:
                        guard let data = response.data,
                            let getResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                                completion(false, nil)
                                return
                        }
                        completion(true, getResponse)
                        strongSelf.isRefreshing = false
                    case .failure:
                        completion(false, nil)
                }
                
                
        }
    }
    
    
    
    
}
