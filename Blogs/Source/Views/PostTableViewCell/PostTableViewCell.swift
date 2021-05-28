//
//  PostTableViewCell.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

  //MARK: - Public Variables
  @IBOutlet weak var avataImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var postTitle: UILabel!
  @IBOutlet weak var postBody: UILabel!
  var viewModel = PostCellVM()
  
  //MARK: - Lifecycle Functions
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    avataImage.layer.masksToBounds = true
    avataImage.layer.cornerRadius = 15
    viewModel.post.bindNotify(key: ObjectIdentifier(self).hashValue) {[weak self] post in
      guard let strongSelf = self else { return }
      strongSelf.performInMainThread {
        strongSelf.populatePost(post)
      }
    }
  }
  
  //MARK: - Public Functions
  func populatePost(_ post: Post?) {
    postTitle?.text = post?.title
    postBody?.text = post?.body
    if let user = post?.user {
      populateUser(user)
    } else if let userId = post?.userId {
      viewModel.getUser(userId)
    }
  }
  
  func populateUser(_ user: User?) {
    userName?.text = user?.name
  }
   
}
