//
//  NetworkServiceTests.swift
//  BlogsTests
//
//  Created by Danny Hoang on 28/05/21.
//

import XCTest
@testable import Blogs

class NetworkServiceTests: XCTestCase {
  let SCHEME = "https"
  let HOST = "jsonplaceholder.typicode.com"
  var mockNetworkService: NetworkService<MockEndpoint>!
  
  override func setUpWithError() throws {
    mockNetworkService = NetworkService<MockEndpoint>()
  }
  
  override func tearDownWithError() throws {
  }
  
  func testNetworkServiceBuildRequestIdSuccessful() {
    do {
      let request = try mockNetworkService.buildRequest(from: .getPosts)
      XCTAssertEqual(request.url?.scheme, SCHEME)
      XCTAssertEqual(request.url?.host, HOST)
      XCTAssertEqual(request.url?.path, "/posts")
      XCTAssertEqual(request.httpMethod, "GET")
    } catch {
      XCTAssertEqual(error as NSError, NSError(domain: "Network Request", code: 0, userInfo: nil))
    }
  }
  
  func testNetworkServiceBuildRequestWithIdSuccessful() {
    do {
      let request = try mockNetworkService.buildRequest(from: .getUser(14))
      XCTAssertEqual(request.url?.scheme, SCHEME)
      XCTAssertEqual(request.url?.host, HOST)
      XCTAssertEqual(request.url?.path, "/users/14")
      XCTAssertEqual(request.httpMethod, "GET")
    } catch {
      XCTAssertEqual(error as NSError, NSError(domain: "Network Request", code: 0, userInfo: nil))
    }
  }
}
