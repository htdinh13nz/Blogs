//
//  ViewController.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let postsWebService = PostsWebService()
    postsWebService.getPosts { data, err in
      guard let responseData = data else { return }
      do {
        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
        print(jsonObject)
      } catch {
        // Can not parse JSON
      }
    }
  }
  
  
}

