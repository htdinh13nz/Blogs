//
//  PostDetailsVC.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import UIKit

class PostDetailsVC: UIViewController {
  
  // MARK: - Public Variables
  @IBOutlet weak var avataImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var postTitleLabel: UILabel!
  @IBOutlet weak var postBodyLabel: UILabel!
  var viewModel = PostDetailsVM()
  
  //MARK: - Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    avataImageView.layer.masksToBounds = true
    avataImageView.layer.cornerRadius = 30
    
    viewModel.post.bindNotify(key: ObjectIdentifier(self).hashValue) {[weak self] post in
      guard let strongSelf = self else { return }
      strongSelf.performInMainThread(block: {
        strongSelf.populatePost(post)
      })
    }
  }
  
  //MARK: - Privated Functions
  private func populatePost(_ post: Post?) {
    postTitleLabel.text = ""
    postBodyLabel.text = ""
    userNameLabel.text = ""
    userEmailLabel.text = ""
    guard let `post` = post else { return }
    postTitleLabel.text = post.title
    postBodyLabel.text = post.body
    if let user = post.user {
      populateUser(user)
    } else {
      viewModel.getUser(post.userId)
    }
  }
  
  private func populateUser(_ user: User?) {
    userNameLabel.text = ""
    userEmailLabel.text = ""
    guard let `user` = user else { return }
    userNameLabel.text = user.name
    userEmailLabel.text = user.email
  }
  
}
