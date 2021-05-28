//
//  ListPostsViewModel.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

class ListPostsVM {
  
  //MARK: - Public Variables
  var posts: MultipleBindingValue<[Post]?> = MultipleBindingValue(value: nil)
  var getPostsError: MultipleBindingValue<String?> = MultipleBindingValue(value: nil)
  
  //MARK: - Private Variables
  private let postsWebService = PostsWebService()
  
  //MARK: - Public Functions
  func getPosts() {
    postsWebService.getPosts {[weak self] posts, error in
      guard let strongSelf = self else { return }
      strongSelf.posts.value = posts
      strongSelf.getPostsError.value = error
    }
  }
}
