//
//  HTTPClientTests.swift
//  
//
//  Created by Milly Guitron on 6/16/22.
//

import XCTest
import SwiftyJSON
import Alamofire
import Foundation

@testable import SwiftHelpers

class HTTPClientTests: XCTestCase {
    func testClientConformsToAlamofireJSONClient() {
        let expectation = self.expectation(description: "It conforms to the protocol")
        
        if HTTPClient.self is AlamofireJSONClient.Type {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchFromEndpoint() {
        let testURL = URLComponents.init(string: "https://example.com/")!
        let mockConfiguration = MockConfiguration.init()
        mockConfiguration.setStatusCode(200)
        mockConfiguration.setDataResponse(TestData.sampleDataJSON.data)
        mockConfiguration.setAPIURL(testURL)
        mockConfiguration.ignoreQuery = true
        let session = mockConfiguration.mockAPIResponse()

        let expectation = self.expectation(description: "The correct endpoint was called")
        guard let expectedJSON = try? JSON(data: TestData.sampleDataJSON.data) else { XCTFail("Failed to parse test JSON"); return }

        let client = HTTPClient(
            sessionManager: session,
            serviceLocatorURL: testURL
        )
        client.setHTTPHeaders(HTTPHeaders.default)
        
        client.onSuccess = { (actualResponse: JSON?) -> Void in
            XCTAssertNotNil(actualResponse)
            XCTAssertEqual(actualResponse, expectedJSON)
            expectation.fulfill()
        }
        client.onFailure = { (_: Int?, _: String?) -> Void in
            XCTFail("onFailure handler was not supposed to be called")
        }
        client.fetch()

        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testFetchFailedFromEndpoint() {
        let testURL = URLComponents.init(string: "https://example.com/")!
        let mockConfiguration = MockConfiguration.init()
        mockConfiguration.setStatusCode(400)
        mockConfiguration.setError("Bad Request")
        mockConfiguration.setDataResponse(TestData.sampleDataJSON.data)
        mockConfiguration.setAPIURL(testURL)
        mockConfiguration.ignoreQuery = true
        let session = mockConfiguration.mockAPIResponse()

        let expectation = self.expectation(description: "onError handler called")

        let client = HTTPClient(
            sessionManager: session,
            serviceLocatorURL: testURL
        )
        client.onSuccess = { (_: JSON?) -> Void in
            XCTFail("onSuccess should not have been called")
        }
        client.onFailure = { (_: Int?, _: String? ) -> Void in
            expectation.fulfill()
        }
        client.fetch()

        wait(for: [expectation], timeout: 2.0)
    }
}
