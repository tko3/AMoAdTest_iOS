//
//  HistoryView.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/11.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit

class HistoryView: UIView {

  var delegate: HistoryViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.4
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }

  private func clearSubViews() {
    self.subviews.forEach { v in
      v.removeFromSuperview()
    }
  }

  func show(frame: CGRect, histories: [String]?) {
    guard let hs = histories, hs.count != 0 else { return }
    self.isHidden = false
    self.frame = CGRect(x: frame.origin.x,
                        y: frame.origin.y,
                        width: frame.width,
                        height: CGFloat(30 * hs.count))

    var count = 0
    hs.forEach { history in
      let lbl = UILabel(frame: CGRect(x: 0,
                                      y: CGFloat(30 * count),
                                      width: frame.width,
                                      height: 30.0))
      lbl.layer.borderColor = UIColor.lightGray.cgColor
      lbl.layer.borderWidth = 0.2
      lbl.text = history
      lbl.isUserInteractionEnabled = true
      let gesture = UITapGestureRecognizer(target: self,
                                           action: #selector(HistoryView.tappedHistory(_:)))
      lbl.addGestureRecognizer(gesture)
      gesture.delegate = self
      self.addSubview(lbl)
      count += 1
    }
  }

  func hide() {
    self.isHidden = true
    clearSubViews()
  }
}

extension HistoryView: UIGestureRecognizerDelegate {
  @objc func tappedHistory(_ sender: UITapGestureRecognizer) {
    guard let label = sender.view as? UILabel else { return }
    self.delegate?.onSelected(text: label.text!)
    self.hide()
  }
}

protocol HistoryViewDelegate {
  func onSelected(text: String)
}
