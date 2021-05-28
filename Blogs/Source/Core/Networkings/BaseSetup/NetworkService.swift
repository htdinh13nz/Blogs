//
//  NetworkService.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

// MARK: - Enums

enum NetworkResponse: String {
  case success
  case networkFailed = "Network request failed"
  case badRequest = "Bad request"
  case notFound = "Can not find data"
  case emptyResponse = "Response returned with no data to decode"
  case unableDecode = "We could not decode the response"
  case networkError = "Please check your network connection"
  case outOfDated = "The url you requested is outdated."
}

enum Result<String> {
  case success
  case failure(String)
}

enum HTTPMethod: String {
  case get = "GET"
}

// MARK: - Type Aliases
typealias NetworkRequestCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

// MARK: - Protocols
protocol NetworkProtocol {
  associatedtype Endpoint: EndpointProtocol
  func request(_ endpoint: Endpoint, completion: @escaping NetworkRequestCompletion)
}

protocol EndpointProtocol {
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
}

// MARK: - Class Implementation
class NetworkService<Endpoint: EndpointProtocol>: NetworkProtocol {
  
  private var urlSession: URLSession
  
  // Initialize function to inject urlSession to NetworkService, default is URLSession.shared
  init(_ urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
    let requestURLString = endpoint.baseURL.absoluteString + "/" + endpoint.path
    guard let requestURL = URL(string: requestURLString) else { throw NSError(domain: "Network Request", code: 0, userInfo: nil) }
    var request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = endpoint.httpMethod.rawValue
    return request
  }
  
  // Implement NetworkProtocol
  func request(_ endpoint: Endpoint, completion: @escaping NetworkRequestCompletion) {
    var task: URLSessionTask?
    do {
      let request = try self.buildRequest(from: endpoint)
      NetworkLogger.log(request: request)
      task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
        completion(data, response, error)
      })
    } catch {
      completion(nil, nil, error)
    }
    task?.resume()
  }
}
