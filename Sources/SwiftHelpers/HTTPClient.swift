//
//  HTTPClient.swift
//  
//
//  Created by Milly Guitron on 4/4/22.
//

import Alamofire
import SwiftyJSON
import Foundation

open class EncodableHTTPQueryParameters: Encodable {
    public init() { }
}

open class HTTPClient: AlamofireJSONClient {
    
    public var sessionManager: Session
    var serviceLocatorConfi: URLComponents
    public var onSuccess: ((JSON?) -> Void)?
    public var onFailure: ((Int?, String?) -> Void)?
    public var queryParameters: [String : String]


    public init(
        sessionManager session: Alamofire.Session,
        serviceLocatorURL config: URLComponents
    ) {
        self.queryParameters = ["" : ""]
        self.sessionManager = session
        self.serviceLocatorConfi = config
    }
    
    public func setQueryParameters(_ params: [String : String]) {
        self.queryParameters = params
    }

    public func fetch() {
        guard let urlString = self.serviceLocatorConfi.string else { return }
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL(string: encoded) else { return }
        
        sessionManager.request(url, parameters: queryParameters).responseString { response in
            self.handleResponse(response)
        }
    }
}
