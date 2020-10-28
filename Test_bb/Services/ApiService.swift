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
    
    static var baseUrl: String = "https://d2t41j3b4bctaz.cloudfront.net/"
    
    private static var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(5)
        configuration.timeoutIntervalForRequest = TimeInterval(5)
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
//        configuration.urlCache = URLCache(memoryCapacity: 40 * 1024 * 1024, diskCapacity: 80 * 1024 * 1024, diskPath: nil)
        
        return SessionManager(configuration: configuration)
    }()
    
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    static private func getHeaders(requiresAuth: Bool = true) -> HTTPHeaders {
        var _headers = HTTPHeaders()
        _headers["Content-Type"] = "Application/json"
        _headers["Accept"] = "Application/json"
        
        return _headers
    }
    
    @discardableResult static private func genericRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any]?, completion: @escaping (T?) -> Void, errorHandler: @escaping (_ error: NSError?) -> Void, requiresAuth: Bool = true, v2_0: Bool = false) -> DataRequest {
        
        let fullUrl = baseUrl + endpoint
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        
        let request = sessionManager.request(fullUrl, method: method, parameters: params, encoding: encoding, headers: getHeaders(requiresAuth: requiresAuth))
        
        request.responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                if let responseData = response.data {
                    print("api response for ", endpoint, ": ", response)
                    do {
                        let data = try decoder.decode(T.self, from: responseData)
                        completion(data)
                    } catch {
                        print("Error decoding data")
                        print(error)
                        errorHandler(error as NSError?)
                    }
                } else {
                    completion(nil)
                }
            } else {
                print(response.error as Any)
                let nsError = response.error as NSError?
                if nsError?.code == -999 { // cancelled
                    return
                }
                errorHandler(nsError)
            }
        }
    
        return request
    }
    
    static let defaultErrorHandler = {(error: NSError?) in
        let domain = error?.domain ?? "Unknown error"
        let message = error?.localizedDescription ?? "Unknown error"
        print("Api error: %@: %@", domain, message)
    }
    
    @discardableResult static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, completion: @escaping (T?) -> Void, requiresAuth: Bool = true) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: [:], completion: completion, errorHandler: defaultErrorHandler, requiresAuth: requiresAuth)
    }
    
    @discardableResult static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, completion: @escaping (T?) -> Void, errorHandler: @escaping (_ error: NSError?) -> Void, requiresAuth: Bool = true) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: [:], completion: completion, errorHandler: errorHandler, requiresAuth: requiresAuth)
    }
    
    @discardableResult static func apiRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any], completion: @escaping (T?) -> Void, requiresAuth: Bool = true) -> DataRequest {
        return genericRequest(method: method, endpoint: endpoint, params: params, completion: completion, errorHandler: defaultErrorHandler, requiresAuth: requiresAuth)
    }
}
