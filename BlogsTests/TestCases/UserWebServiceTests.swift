//
//  UserWebServiceTests.swift
//  BlogsTests
//
//  Created by Danny Hoang on 28/05/21.
//

import XCTest

class UserWebServiceTests: XCTestCase {
  
  var userWebService: UserWebService!
  var session:URLSession!
  var expectation: XCTestExpectation!
  
  override func setUpWithError() throws {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    session = URLSession(configuration: config)
    let networkService = NetworkService<UserEndpoint>(session)
    userWebService = UserWebService(networkService)
    expectation = self.expectation(description: "Get user")
  }
  
  override func tearDownWithError() throws {
    userWebService = nil
    session = nil
  }
  
  func testPostsWebService_WhenGivenSuccessfullResponse() {
    let jsonString = "{\"id\": 1, \"name\": \"Leanne Graham\", \"username\": \"Bret\", \"email\": \"Sincere@april.biz\",\"address\": {\"street\": \"Kulas Light\",\"suite\": \"Apt. 556\",\"city\": \"Gwenborough\",\"zipcode\": \"92998-3874\",\"geo\": {\"lat\": \"-37.3159\",\"lng\": \"81.1496\"}},\"phone\": \"1-770-736-8031 x56442\",\"website\": \"hildegard.org\",\"company\": {\"name\": \"Romaguera-Crona\",\"catchPhrase\": \"Multi-layered client-server neural-net\",\"bs\": \"harness real-time e-markets\"}}"
    setupRequestHandler(jsonString, statusCode: 200)
    userWebService.getUser(1) { user, err in
      guard let _ = user else { XCTAssertFalse(true, "Response is nil"); return;}
      XCTAssertTrue(user?.id == 1)
      XCTAssertEqual(user?.email, "Sincere@april.biz")
      XCTAssertEqual(user?.name, "Leanne Graham")
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostWebService_WhenReceivedDifferentJSONResponse() {
    let jsonString = "{\"foo\": 10}"
    setupRequestHandler(jsonString, statusCode: 200)
    
    userWebService.getUser(1) { user, err in
      XCTAssertNil(user)
      XCTAssertEqual(err, NetworkResponse.unableDecode.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenIncorrectResponse() {
    let jsonString = "{\"name\": \"Leanne Graham\", \"username\": \"Bret\", \"email\": \"Sincere@april.biz\",\"address\": {\"street\": \"Kulas Light\",\"suite\": \"Apt. 556\",\"city\": \"Gwenborough\",\"zipcode\": \"92998-3874\",\"geo\": {\"lat\": \"-37.3159\",\"lng\": \"81.1496\"}},\"phone\": \"1-770-736-8031 x56442\",\"website\": \"hildegard.org\",\"company\": {\"name\": \"Romaguera-Crona\",\"catchPhrase\": \"Multi-layered client-server neural-net\",\"bs\": \"harness real-time e-markets\"}}"
    setupRequestHandler(jsonString, statusCode: 200)
    userWebService.getUser(1) { user, err in
      XCTAssertNil(user)
      XCTAssertEqual(err, NetworkResponse.unableDecode.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenNotFoundResponse() {
    setupRequestHandler("{}", statusCode: 404)
    userWebService.getUser(1) { user, err in
      XCTAssertNil(user)
      XCTAssertEqual(err, NetworkResponse.notFound.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenBadRequestResponse() {
    setupRequestHandler("{}", statusCode: 500)
    
    userWebService.getUser(1) { user, err in
      XCTAssertNil(user)
      XCTAssertEqual(err, NetworkResponse.badRequest.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenOutOfDatedRequestResponse() {
    setupRequestHandler("{}", statusCode: 600)
    
    userWebService.getUser(1) { user, err in
      XCTAssertNil(user)
      XCTAssertEqual(err, NetworkResponse.outOfDated.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenNetworkFailRequestResponse() {
    setupRequestHandler("{}", statusCode: 700)
    
    userWebService.getUser(1) { user, err in
      XCTAssertNil(user)
      XCTAssertEqual(err, NetworkResponse.networkFailed.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
}
