//
//  PostsEndpoint.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

public enum PostsEndpoint {
  case getPosts
}

//MARK: Conform to EndpointProtocol
extension PostsEndpoint: EndpointProtocol {
  var baseURL: URL {
    guard  let url = URL(string: "https://jsonplaceholder.typicode.com") else {
      fatalError("PostsService baseURL could not be configured.")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .getPosts:
      return "posts"
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
}
