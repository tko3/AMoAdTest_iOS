//
//  ViewControllerExtension.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit

extension UIViewController {

  func showAlert(message: String) {
    let alert: UIAlertController = UIAlertController(title: "入力エラー", message: message, preferredStyle: .alert)
    let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }

  func addLog(message: String, view: UITextView) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ "
    let date = formatter.string(from: Date())
    view.text += date + message + "\n"
  }

  func addHistory(viewName: String, sid: String) {
    var newList: [String]!
    if let current = UserDefaults.standard.array(forKey: viewName) {
      newList = current as? [String]
    } else {
      newList = [String]()
    }

    if (newList.count >= historyMaxCount) {
      newList.removeFirst()
    }

    newList.append(sid)
    UserDefaults.standard.set(newList, forKey: viewName)
  }

  func getHistory(viewName: String) -> [String]? {
    return UserDefaults.standard.array(forKey: viewName) as? [String]
  }
}
