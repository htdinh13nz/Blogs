//
//  XCTestCase+Extensions.swift
//  BlogsTests
//
//  Created by Danny Hoang on 28/05/21.
//

import XCTest
extension XCTestCase {

  func setupRequestHandler(_ payload: String, statusCode: Int) {
    let jsonString = payload
    let data = jsonString.data(using: .utf8)
    MockURLProtocol.requestHandler = { request in
      guard let url = request.url else {
        XCTFail("Missing URL on request")
        return (HTTPURLResponse(), nil)
      }
      
      let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
      return (response, data)
    }
  }

}
