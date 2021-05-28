//
//  ViewController.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import UIKit

class ListPostsVC: UIViewController {
  
  //MARK: - Public Variables
  @IBOutlet weak var postsCountLabel: UILabel!
  @IBOutlet weak var postsTableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var indicatorView: UIView!
  var viewModel = ListPostsVM()
  
  //MARK: - Private Variables
  private var isLoading = false
  override func viewDidLoad() {
    super.viewDidLoad()
    
    indicatorView.layer.masksToBounds = true
    indicatorView.layer.cornerRadius = 10
    
    postsCountLabel.text = "All posts"
    
    let postTableViewCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
    postsTableView.register(postTableViewCellNib, forCellReuseIdentifier: "PostTableViewCell")
    
    let retryTableViewCell = UINib(nibName: "RetryTableViewCell", bundle: nil)
    postsTableView.register(retryTableViewCell, forCellReuseIdentifier: "RetryTableViewCell")
    
    
    viewModel.posts.bindNotify(key: ObjectIdentifier(self).hashValue){ [weak self] posts in
      guard let strongSelf = self else { return }
      defer {
        strongSelf.performInMainThread {
          strongSelf.toggleLoading(false)
        }
      }
      strongSelf.performInMainThread {
        strongSelf.postsTableView.reloadData()
      }
    }
    
    viewModel.getPostsError.bind(key: ObjectIdentifier(self).hashValue){[weak self] error in
      guard let strongSelf = self else { return }
      strongSelf.performInMainThread {
        strongSelf.populatePosts()
      }
    }
    
    viewModel.getPosts()
    toggleLoading(true)
  }
  
  //MARK: - Private Functions
  private func populatePosts() {
    postsTableView.reloadData()
    let numOfPosts = viewModel.posts.value?.count ?? 0
    postsCountLabel.text = numOfPosts == 0 ? "All Posts" : "Total: \(numOfPosts) Posts"
  }
  
  private func toggleLoading(_ show: Bool){
    isLoading = show
    
    if show {
      loadingView.isHidden = false
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.loadingView.alpha = 1
      }
    } else {
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.loadingView.alpha = 1
      } completion: { [weak self] completed in
        guard let strongSelf = self else { return }
        if completed {
          strongSelf.loadingView.isHidden = true
        }
      }

    }

  }

}

//MARK: - UITableViewDataSource Implementations
extension ListPostsVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let dataSource = viewModel.posts.value else {
      // Return 1 for retry cell if there is not any post after fetch
      return isLoading ? 0 : 1
    }
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dataSource = viewModel.posts.value else {
      // Show retry cell if there is not any data to display on table view
      
      guard let retryCell = tableView.dequeueReusableCell(withIdentifier: "RetryTableViewCell", for: indexPath) as? RetryTableViewCell else {
        return UITableViewCell()
      }
  
      retryCell.messageLabel.text = "Can not fetch list of posts"
      retryCell.actionHandler = {[weak self] in
        guard let strongSelf = self else { return }
        strongSelf.viewModel.getPosts()
        strongSelf.performInMainThread {
          strongSelf.toggleLoading(true)
        }
      }
      return retryCell
    }
    
    // Populate post to PostTableViewCell.
    guard let postCell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
      return UITableViewCell()
    }
    
    postCell.viewModel.post.value = dataSource[indexPath.row]
    
    return postCell
  }
  
}

//MARK: - UITableViewDelegate Implementations
extension ListPostsVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let dataSource = viewModel.posts.value else { return }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let postDetailsVC = storyboard.instantiateViewController(identifier: "PostDetailsVC") as? PostDetailsVC else { return}
    
    postDetailsVC.viewModel.post.value = dataSource[indexPath.row]
    navigationController?.pushViewController(postDetailsVC, animated: true)
  }
}
