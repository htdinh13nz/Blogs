//
//  PostsWebServiceTests.swift
//  BlogsTests
//
//  Created by Danny Hoang on 28/05/21.
//

import XCTest
@testable import Blogs

class PostsWebServiceTests: XCTestCase {
  var postWebService: PostsWebService!
  var session:URLSession!
  var expectation: XCTestExpectation!
  
  override func setUpWithError() throws {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    session = URLSession(configuration: config)
    let networkService = NetworkService<PostsEndpoint>(session)
    postWebService = PostsWebService(networkService)
    expectation = self.expectation(description: "Get posts list")
  }

  override func tearDownWithError() throws {
    postWebService = nil
    session = nil
  }
    
  func testPostsWebService_WhenGivenSuccessfullResponse() {
    let jsonString = "[{\"userId\":1,\"id\":1,\"title\":\"suntautfacererepellatprovidentoccaecatiexcepturioptioreprehenderit\",\"body\":\"quiaetsuscipit\\nsuscipitrecusandaeconsequunturexpeditaetcum\\nreprehenderitmolestiaeututquastotam\\nnostrumrerumestautemsuntremevenietarchitecto\"},{\"userId\":1,\"id\":2,\"title\":\"quiestesse\",\"body\":\"estrerumtemporevitae\\nsequisintnihilreprehenderitdolorbeataeeadoloresneque\\nfugiatblanditiisvoluptateporrovelnihilmolestiaeutreiciendis\\nquiaperiamnondebitispossimusquinequenisinulla\"},{\"userId\":1,\"id\":3,\"title\":\"eamolestiasquasiexercitationemrepellatquiipsasitaut\",\"body\":\"etiustosedquoiure\\nvoluptatemoccaecatiomniseligendiautad\\nvoluptatemdoloribusvelaccusantiumquispariatur\\nmolestiaeporroeiusodioetlaboreetvelitaut\"},{\"userId\":1,\"id\":4,\"title\":\"eumetestoccaecati\",\"body\":\"ullametsaepereiciendisvoluptatemadipisci\\nsitametautemassumendaprovidentrerumculpa\\nquishiccommodinesciuntremteneturdoloremqueipsamiure\\nquissuntvoluptatemrerumillovelit\"},{\"userId\":1,\"id\":5,\"title\":\"nesciuntquasodio\",\"body\":\"repudiandaeveniamquaeratsuntsed\\naliasautfugiatsitautemsedest\\nvoluptatemomnispossimusessevoluptatibusquis\\nestautteneturdolorneque\"},{\"userId\":1,\"id\":6,\"title\":\"doloremeummagnieosaperiamquia\",\"body\":\"utaspernaturcorporisharumnihilquisprovidentsequi\\nmollitianobisaliquidmolestiae\\nperspiciatiseteanemoabreprehenderitaccusantiumquas\\nvoluptatedoloresvelitetdoloremquemolestiae\"}]"
    setupRequestHandler(jsonString, statusCode: 200)
    
    postWebService.getPosts({ posts, error in
      guard let _ = posts else { XCTAssertFalse(true, "Response is nil"); return;}
      XCTAssertTrue(posts!.count > 0)
      self.expectation.fulfill()
    })
    self.wait(for: [expectation], timeout: 5)
  }

  
  func testPostWebService_WhenReceivedDifferentJSONResponse() {
    let jsonString = "{\"foo\": 10}"
    setupRequestHandler(jsonString, statusCode: 200)
    
    postWebService.getPosts({ posts, error in
      XCTAssertNil(posts)
      XCTAssertEqual(error, NetworkResponse.unableDecode.rawValue)
      self.expectation.fulfill()
    })
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenNotFoundResponse() {
    setupRequestHandler("{}", statusCode: 404)
    postWebService.getPosts{ posts, err in
      XCTAssertNil(posts)
      XCTAssertEqual(err, NetworkResponse.notFound.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenBadRequestResponse() {
    setupRequestHandler("{}", statusCode: 500)
    
    postWebService.getPosts{ posts, err in
      XCTAssertNil(posts)
      XCTAssertEqual(err, NetworkResponse.badRequest.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenOutOfDatedRequestResponse() {
    setupRequestHandler("{}", statusCode: 600)
    
    postWebService.getPosts{ posts, err in
      XCTAssertNil(posts)
      XCTAssertEqual(err, NetworkResponse.outOfDated.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testPostsWebService_WhenGivenNetworkFailRequestResponse() {
    setupRequestHandler("{}", statusCode: 700)
    
    postWebService.getPosts { posts, err in
      XCTAssertNil(posts)
      XCTAssertEqual(err, NetworkResponse.networkFailed.rawValue)
      self.expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 5)
  }
}
