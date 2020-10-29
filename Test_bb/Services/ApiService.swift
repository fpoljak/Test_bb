//
//  ApiService.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation
import Alamofire

public class ApiService {
    
    static var baseUrl: String = "https://d2t41j3b4bctaz.cloudfront.net"
    
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
    static private func genericRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any]?, completion: @escaping (T?) -> Void, errorHandler: @escaping (_ error: NSError?) -> Void) -> DataRequest {
        
        let fullUrl = baseUrl + "/" + endpoint
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        
        let request = sessionManager.request(fullUrl, method: method, parameters: params, encoding: encoding, headers: getHeaders())
        
        request.responseDecodable(of: T.self, decoder: decoder) { (response: DataResponse<T, AFError>) in
            if let error = response.error {
                let nsError = error.underlyingError as NSError?
                if nsError?.code == -999 { // cancelled
                    return
                }
                errorHandler(nsError)
                return
            }
            if let value = response.value as T? {
                completion(value)
                return
            }
            completion(nil)
        }
        
        return request
    }
    
    static let defaultErrorHandler = {(error: NSError?) in
        let domain = error?.domain ?? "Unknown error"
        let message = error?.localizedDescription ?? "Unknown error"
        print("Api error: ", domain, ": ", message)
    }
    
    @discardableResult
    static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, completion: @escaping (T?) -> Void) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: [:], completion: completion, errorHandler: defaultErrorHandler)
    }
    
    @discardableResult
    static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, completion: @escaping (T?) -> Void, errorHandler: @escaping (_ error: NSError?) -> Void) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: [:], completion: completion, errorHandler: errorHandler)
    }
    
    @discardableResult
    static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any], completion: @escaping (T?) -> Void) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: params, completion: completion, errorHandler: defaultErrorHandler)
    }
    
    @discardableResult
    static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any], completion: @escaping (T?) -> Void, errorHandler: @escaping (_ error: NSError?) -> Void) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: params, completion: completion, errorHandler: errorHandler)
    }
}
