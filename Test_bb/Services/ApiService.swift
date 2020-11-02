//
//  ApiService.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public class ApiService {
    static var baseUrl: String {
        get {
            if ProcessInfo.processInfo.arguments.contains("TESTING") {
                return "http://localhost:8080"
            } else {
                return "https://d2t41j3b4bctaz.cloudfront.net"
            }
        }
    }
    
    private static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(10)
        configuration.timeoutIntervalForRequest = TimeInterval(10)
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
//        configuration.urlCache = URLCache(memoryCapacity: 40 * 1024 * 1024, diskCapacity: 80 * 1024 * 1024, diskPath: nil)

        return Session.init(configuration: configuration)
    }()
    
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    static private func getHeaders() -> HTTPHeaders {
        var _headers = HTTPHeaders()
        _headers["Content-Type"] = "Application/json"
        _headers["Accept"] = "Application/json"
        
        return _headers
    }
    
    @discardableResult
    static func genericRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any]? = nil, responseType: T.Type) -> Observable<T?> {
        return Observable.create { observer -> Disposable in
        
            let fullUrl = baseUrl + "/" + endpoint
            let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
            
            let request = sessionManager.request(fullUrl, method: method, parameters: params, encoding: encoding, headers: getHeaders())
            
            request.responseDecodable(of: T.self, decoder: decoder) { (response: DataResponse<T, AFError>) in
                if let error = response.error {
                    let nsError = error.underlyingError as NSError?
                    if nsError?.code == -999 { // cancelled
                        return
                    }
                    observer.onError(error)
                    return
                }
                if let value = response.value as T? {
                    observer.onNext(value)
                    return
                }
                observer.onNext(nil)
            }
            
            return Disposables.create()
        }
    }
    
    static let defaultErrorHandler = {(error: Error) in
        let error = error as NSError
        let domain = error.domain
        let message = error.localizedDescription
        print("Api error: ", domain, ": ", message)
    }
}
