//
//  PostsWebService.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

struct PostsWebService {
  private var networkService:NetworkService<PostsEndpoint>!
  init(_ networkService: NetworkService<PostsEndpoint> = NetworkService<PostsEndpoint>()) {
    self.networkService = networkService
  }
  
  func getPosts(_ completion: @escaping (_ getPostsResponse: Data?, _ error: String?) ->()) {
    networkService.request(.getPosts) { data, res, err in
      if err != nil {
        completion(nil, NetworkResponse.networkError.rawValue)
      }
      
      guard let response = res as? HTTPURLResponse else { return }
      let result = self.handlePostsResponse(response)
      switch result {
      case .success:
        completion(data, nil)
      case .failure(let networkFailureError):
        completion(nil, networkFailureError)
      }
    }
  }
  
  
  func handlePostsResponse(_ res: HTTPURLResponse) -> Result<String> {
    switch res.statusCode {
    case 200...299: return .success
    case 404: return .failure(NetworkResponse.notFound.rawValue)
    case 500...599: return .failure(NetworkResponse.badRequest.rawValue)
    case 600: return .failure(NetworkResponse.outOfDated.rawValue)
    default: return .failure(NetworkResponse.networkFailed.rawValue)
    }
  }
  
}
