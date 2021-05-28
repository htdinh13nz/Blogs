//
//  MockEndpoint.swift
//  BlogsTests
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

public enum MockEndpoint {
  case getUser(_ userId: Int)
  case getPosts
}

extension MockEndpoint: EndpointProtocol {
  
  var environmentBaseURL: String {
    return "https://jsonplaceholder.typicode.com"
  }
  
  var baseURL: URL {
    guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
    return url
  }
  
  var path: String {
    switch self {
    case .getUser(let userId):
      return "users/\(userId)"
      
    case .getPosts:
      return "posts"
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
}
