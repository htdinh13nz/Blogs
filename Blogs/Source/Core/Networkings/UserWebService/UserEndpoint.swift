//
//  UserEndpoint.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation


public enum UserEndpoint {
  case getUser(_ userId: Int)
}

//MARK: Conform to EndpointProtocol
extension UserEndpoint: EndpointProtocol {
  
  var baseURL: URL {
    guard  let url = URL(string: "https://jsonplaceholder.typicode.com") else {
      fatalError("PostsService baseURL could not be configured.")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .getUser(let userId):
      return "users/\(userId)"
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
}
