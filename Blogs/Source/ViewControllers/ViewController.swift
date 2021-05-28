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
    postsWebService.getPosts { posts, err in
      guard let `posts` = posts else { return }
      print(posts)
    }
  }
  
  
}

