//
//  HTTPClient.swift
//  
//
//  Created by Milly Guitron on 4/4/22.
//

import Alamofire
import SwiftyJSON

public protocol AlamofireJSONClient {
    var sessionManager: Alamofire.Session { get set }
    var onSuccess: ((JSON?) -> Void)? { get set }
    var onFailure: ((Int?, String?) -> Void)? { get set }
    
    func fetch() -> Void
    func handleResponse(_ response: AFDataResponse<String>) -> Void
}

extension AlamofireJSONClient {
    public func handleResponse(_ response: AFDataResponse<String>) -> Void {
        switch response.result {
        case .success(let value):
            if let onSuccess = self.onSuccess {
                onSuccess(JSON(parseJSON: value))
            }
        case .failure(let error):
            debugPrint(error)
            if let onFailure = onFailure {
                onFailure(error.responseCode, error.errorDescription)
            }
        }
    }
}
