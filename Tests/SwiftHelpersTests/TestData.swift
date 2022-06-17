//
//  TestData.swift
//
//
//  Created by Milly Guitron on 6/17/22.
//


import Foundation

public final class TestData {
    public static let sampleDataJSON: URL = Bundle.module.url(forResource: "TestResponse", withExtension: "json")!
}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
