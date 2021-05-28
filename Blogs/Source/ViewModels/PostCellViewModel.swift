//
//  PostCellViewModel.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import Foundation

class PostCellVM {
  //MARK: - Public Variables
  var post: MultipleBindingValue<Post?> = MultipleBindingValue(value: nil)
  
  //MARK: - Private Variables
  private let userWebService = UserWebService()
  
  
  //MARK: - Public Functions
  func getUser(_ userId: Int) {
    userWebService.getUser(userId) {[weak self] user, err in
      guard let strongSelf = self else { return }
      guard var post = strongSelf.post.value else { return }
      post.user = user
      strongSelf.post.value = post
    }
  }
}
