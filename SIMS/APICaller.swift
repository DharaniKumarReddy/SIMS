//
//  APICaller.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

typealias JSONDictionary = [String : AnyObject]
typealias OnSuccessResponse = (String) -> Void
typealias OnErrorMessage = (String) -> Void

typealias OnUserResponse = (Member) -> Void

private enum RequestMethod: String, CustomStringConvertible {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
    
    var description: String {
        return rawValue
    }
}

class APICaller {
    
    let MAX_RETRIES = 2
    
    private var urlSession: URLSession
    
    class func getInstance() -> APICaller {
        struct Static {
            static let instance = APICaller()
        }
        return Static.instance
    }
    
    private init() {
        urlSession = APICaller.createURLSession()
    }
    
    private class func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        configuration.httpAdditionalHeaders = [
            "Accept"       : "application/json",
            "Content-Type" : "application/json; charset=utf-8",
        ]
        
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    private func resetURLSession() {
        urlSession.invalidateAndCancel()
        urlSession = APICaller.createURLSession()
    }
    
    private func createRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, sectionName: String? = nil) -> URLRequest {
        let request = NSMutableURLRequest(url: absoluteURL)
        request.httpMethod = requestMethod.rawValue
        
//        if let token = KeyChainStore.sharedStore().token {
//            request.addValue(token.authorizationHeaderString(), forHTTPHeaderField: "X-API-Authorization")
//        }
        
        let defaults = UserDefaults.standard
        if defaults.string(forKey: Keys.Token) != nil {
            
        }
        
        
        if var params = params {
            params["cmd"] = route.cmd as AnyObject
            switch requestMethod {
            case .GET, .DELETE:
                var queryItems: [URLQueryItem] = []
                
                for (key, value) in params {
                    
                    if let valued = value as? String {
                        if valued == "All Devices %26 Apps"{
                            queryItems.append(URLQueryItem(name: "\(key)", value: "All Devices UNIQUE Apps"))
                        }else {
                            queryItems.append(URLQueryItem(name: "\(key)", value: "\(value)"))
                        }
                    } else {
                        queryItems.append(URLQueryItem(name: "\(key)", value: "\(value)"))
                    }
                }
                
                if queryItems.count > 0 {
                    var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
                    components?.queryItems = queryItems
                    
                    components?.percentEncodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "UNIQUE", with: "%26", options: NSString.CompareOptions.literal, range: nil)
                    components?.percentEncodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
                    components?.percentEncodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%2520", with: "%20", options: NSString.CompareOptions.literal, range: nil)
                    
                    request.url = components?.url
                }
                
            case .POST, .PUT:
                
                
                var error: NSError?
                do {
                    let body = try JSONSerialization.data(withJSONObject: params, options: [])
                    request.httpBody = body
                    
                } catch let error1 as NSError {
                    error = error1
                    if let errorMessage = error?.localizedDescription {
                        print(errorMessage)
                    } else {
                        print("Unexpected JSON Parse Error requestWithOperation: \(requestMethod) \(absoluteURL)")
                    }
                }
            }
        }
        print(request)
        return request as URLRequest
    }
    
    private func enqueueRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, retryCount: Int = 0, onSuccessResponse: @escaping (String) -> Void, onErrorMessage: @escaping OnErrorMessage) {
        
        let urlRequest = createRequest(requestMethod, route, params: params)
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                var statusCode = httpResponse.statusCode
                var responseString:String = ""
                if let responseData = data {
                    responseString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) as String? ?? ""
                }else {
                    statusCode = 450
                }
                print(responseString)
                let json = JSON(parseJSON: responseString)
                if json["mydata"] == "" {
                    statusCode = 400
                }
                switch statusCode {
                case 200...299:
                    // Success Response
                    
                    //TODO: should change the way we handle 500 error
                    if responseString.contains("A generic error occurred in GDI+."){
                        onErrorMessage(responseString)
                    }else {
                        onSuccessResponse(responseString)
                    }
                    
                default:
                    // Failure Response
                    
                    let errorMessage = "Some thing went wrong. Please try again"
                    onErrorMessage(errorMessage)
                }
                
            } else if let error = error {
                var errorMessage: String
                switch error._code {
                case NSURLErrorNotConnectedToInternet:
                    errorMessage = "Internet connection lost"
                case NSURLErrorNetworkConnectionLost:
                    if retryCount < self.MAX_RETRIES {
                        self.enqueueRequest(requestMethod, route, params: params, retryCount: retryCount + 1, onSuccessResponse: onSuccessResponse, onErrorMessage: onErrorMessage)
                        return
                        
                    } else {
                        errorMessage = error.localizedDescription
                    }
                default:
                    errorMessage = error.localizedDescription
                }
                UIApplication.topViewController()?.showHUDWithText(text: errorMessage)
                onErrorMessage(error.localizedDescription)
                
            } else {
                assertionFailure("Either an httpResponse or an error is expected")
            }
        }) 
        
        dataTask.resume()
    }
    
    func logIn(emailOrMobile id: String?, password: String?, onUserResponse: @escaping OnUserResponse, onError: @escaping OnErrorMessage) {
        let jsonDict: JSONDictionary = ["emailormobile" : id as AnyObject, "password" : password as AnyObject]
        enqueueRequest(
            .GET,
            .login,
            params: jsonDict,
            onSuccessResponse: { response in
                let member = JsonParser.parseMemberInfo(jsonString: response)
                 onUserResponse(member)
            }, onErrorMessage: { errorMessage in
                onError(errorMessage)
        })
    }
}
