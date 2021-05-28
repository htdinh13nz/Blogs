//
//  RetryTableViewCell.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import UIKit

class RetryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var messageLabel: UILabel!
  var actionHandler: (() -> ())?
  
  @IBAction func didTouchRetry(_ sender: Any) {
    if let handler = actionHandler {
      handler()
    } else {
      print("RetryTableViewCell: No Handler")
    }
  }
  
}
