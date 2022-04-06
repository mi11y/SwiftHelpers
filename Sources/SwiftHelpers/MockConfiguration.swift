//
//  MockConfiguration.swift
//
//
//  Created by Milly Guitron on 3/27/22.
//

import Foundation
import Alamofire
import Mocker

public class MockConfiguration {
    
    private var statusCode: Int
    private var payload: Data?
    private var testError: TestAPIError?
    private var apiURL: URLComponents?
    public var ignoreQuery: Bool = false
    
    public init() {
        self.statusCode = 200
    }
    
    public func setStatusCode(_ statusCode: Int) -> Void {
        self.statusCode = statusCode
    }
    
    
    public func setDataResponse(_ data: Data) -> Void {
        self.payload = data
    }
    
    public func setError(_ message: String) -> Void {
        self.testError = TestAPIError.message(message)
    }
    
    public func setAPIURL(_ urlComponents: URLComponents) -> Void {
        self.apiURL = urlComponents
    }
    
    public enum TestAPIError: Error {
        case message(String)
    }
    
    public func mockAPIResponse() -> Session {
        if let urlComponents = self.apiURL {
            self.mockSessionWithComponents(urlComponents)
        }
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        return Alamofire.Session(configuration: configuration)
    }
    
    
    private func mockSessionWithComponents(_ urlComponenets: URLComponents) {
        let apiEndpoint = createURLFromComponents(urlComponenets)
        
        if let error = self.testError, let payload = self.payload {
            Mock(
                url: apiEndpoint,
                ignoreQuery: ignoreQuery,
                dataType: .json,
                statusCode: self.statusCode,
                data: [
                    .get: payload
                ],
                requestError: error
            ).register()
        } else if let payload = self.payload {
            Mock(
                url: apiEndpoint,
                ignoreQuery: ignoreQuery,
                dataType: .json,
                statusCode: self.statusCode,
                data: [
                    .get: payload
                ]
            ).register()
        }
    }
    
    private func createURLFromComponents(_ components: URLComponents) -> URL {
        let characterSet = NSCharacterSet(charactersIn: ",").inverted
        return URL(
            string: components.string!.addingPercentEncoding(
                withAllowedCharacters: characterSet
            )!
        )!
    }
}
