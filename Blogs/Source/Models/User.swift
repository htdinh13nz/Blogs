//
//  User.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

struct User: Identifiable, Codable {
  let id: Int
  let name: String
  let email: String
  let address: Address
  let phone: String
  let website: String
  let company: Company
  
  struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geolocation
    
    struct Geolocation: Codable {
      let lat: String
      let lng: String
    }
  }
  
  struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
  }
}
