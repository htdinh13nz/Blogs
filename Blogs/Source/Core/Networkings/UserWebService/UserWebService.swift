//
//  UserWebService.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

struct UserWebService {
  private var networkService:NetworkService<UserEndpoint>!
  init(_ networkService: NetworkService<UserEndpoint> = NetworkService<UserEndpoint>()) {
    self.networkService = networkService
  }
  
  func getUser(_ userId: Int, _ completion: @escaping (_ getPostsResponse: User?, _ error: String?) ->()) {
    networkService.request(.getUser(userId)) { data, res, err in
      if err != nil {
        completion(nil, NetworkResponse.networkError.rawValue)
      }
      
      guard let response = res as? HTTPURLResponse else { return }
      let result = self.handleUserResponse(response)
      switch result {
      case .success:
        let parseResult = self.parseUserResponse(data)
        completion(parseResult.0, parseResult.1)
      case .failure(let networkFailureError):
        completion(nil, networkFailureError)
      }
    }
  }
  
  
  func handleUserResponse(_ res: HTTPURLResponse) -> Result<String> {
    switch res.statusCode {
    case 200: return .success;
    case 404: return .failure(NetworkResponse.notFound.rawValue);
    case 500...599: return .failure(NetworkResponse.badRequest.rawValue);
    case 600: return .failure(NetworkResponse.outOfDated.rawValue);
    default: return .failure(NetworkResponse.networkFailed.rawValue);
    }
  }
  
  func parseUserResponse(_ data: Data?) -> (User?, String?) {
    guard let responseData = data else { return (nil,  NetworkResponse.emptyResponse.rawValue) }
    do {
      let _ = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
      let apiResponse = try JSONDecoder().decode(User.self, from: responseData)
      return (apiResponse, nil)
    } catch {
      print(error)
      return (nil, NetworkResponse.unableDecode.rawValue)
    }
  }
  
}
