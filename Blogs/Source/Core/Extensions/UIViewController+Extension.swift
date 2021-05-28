//
//  UIViewController+Extension.swift
//  Blogs
//
//  Created by Danny Hoang on 28/05/21.
//

import UIKit

extension UIViewController {
  func performInMainThread( block: @escaping () -> Void) {
    if (Thread.current.isMainThread) {
      block();
    } else {
      DispatchQueue.main.async { block(); }
    }
  }
}
