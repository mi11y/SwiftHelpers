//
//  HTTPClient.swift
//  
//
//  Created by Milly Guitron on 4/4/22.
//

import Alamofire
import SwiftyJSON
import Foundation

/// `HTTPClient` is a class that makes it easier to send GET requests to APIs.
///
/// This class is available for extension and is used by other packages. It relies on Alamofire for
/// performing network communication, and SwiftyJSON for interpreting JSON responses.
///
/// You can interact with successful results or failures of an HTTP request by providing your own `onSuccess` and `onFailure`
/// closures. Query parameters are also supported.
open class HTTPClient: AlamofireJSONClient {
    
    /// An `Alamofire.Session` instance used  by the class to make network calls.
    public var sessionManager: Session
    
    /// This is the API endpoint to send the GET request to. Usually it is provided by some kind of `ServiceLocator`.
    var serviceLocatorConfi: URLComponents
    
    /// This closure is called upon a successful request to the API Endpoint. You should provide a closure to take advantage of the response from the API endpoint you are communicating with.
    public var onSuccess: ((JSON?) -> Void)?
    
    /// This closure is called upon whenever an error is encountered during the request to the API Endpoint. You should provide a closure to handle this situation.
    public var onFailure: ((Int?, String?) -> Void)?
    
    /// Query parameters are URL encoded onto the end of the API URL. For example, `["foo": "bar"]` will be encoded into `https://httpbin.org/get?foo=bar`.
    public var queryParameters: [String : String]
    
    /// `HTTPHEaders` are Alamofire HTTP Headers to be used for this request.
    public var headers: HTTPHeaders


    /// Creates a new instance of an HTTPClient.
    ///
    /// By default the client will be initialized with empty-string query parameters, your provided session manager, and your provided `serviceLocatorURL`
    /// - Parameters:
    ///     - sessionManager: An `Alamofire.Session` manager instance
    ///     - serviceLocatorURL: The API URL Endpoint you wish to communicate with.
    public init(
        sessionManager session: Alamofire.Session,
        serviceLocatorURL config: URLComponents
    ) {
        self.queryParameters = ["":""]
        self.headers = ["":""]
        self.sessionManager = session
        self.serviceLocatorConfi = config
    }
    
    
    /// Sets the client's query Parameters.
    ///
    /// You can update the query parameters to be used in your request to be URL Encoded using this method.
    /// - Parameters:
    ///     - params: A Dictionary of Strings representing keys and values of your URL parameters.
    public func setQueryParameters(_ params: [String : String]) {
        self.queryParameters = params
    }
    
    /// Sets the HTTP headers to be used for this request.
    ///
    /// Provide an Alamofire HTTPHeaders instance to be used for this request.
    /// - Parameters:
    ///     = headers: An Alamofire HTTPHeaders instance (usually a dictionary of key value pairs)
    public func setHTTPHeaders(_ headers: HTTPHeaders) {
        self.headers = headers
    }

    /// Performs the HTTP GET request.
    ///
    /// Call this method after you have configured the client. You should have already set your `onSuccess` and `onFailure` closures, and any `queryParameters` needed.
    public func fetch() {
        guard let urlString = self.serviceLocatorConfi.string else { return }
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL(string: encoded) else { return }
        
        //TODO: If there are no queryParameters present, they should not be passed in, so we wouldn't have to ignoreParams in MockConfiguration.
        sessionManager.request(url, parameters: queryParameters, headers: self.headers).responseString { response in
            self.handleResponse(response)
        }
    }
}
