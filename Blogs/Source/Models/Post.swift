//
//  Post.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation
struct Post: Identifiable, Codable {
  let id: Int
  let userId: Int
  let title: String
  let body: String
  var user: User?
}
