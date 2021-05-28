//
//  NetworkLogger.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

class NetworkLogger {
  static func log(request: URLRequest) {
    
    print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
    
    let urlAsString = request.url?.absoluteString ?? ""
    let urlComponents = NSURLComponents(string: urlAsString)
    
    let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
    let path = "\(urlComponents?.path ?? "")"
    let query = "\(urlComponents?.query ?? "")"
    let host = "\(urlComponents?.host ?? "")"
    
    print("""
        \(urlAsString) \n
        \(method) \(path)?\(query)\n
        HOST: \(host)\n
        """)
  }
}
