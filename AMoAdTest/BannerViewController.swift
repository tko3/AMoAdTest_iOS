//
//  BannerViewController.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import AMoAd

class BannerViewController: UIViewController {
  
  @IBOutlet var sidTextField: UITextField!
  @IBOutlet var logView: UITextView!

  var bannerView: AMoAdView?
  private var historyView: HistoryView!
  
  private var viewName = String(describing: BannerViewController.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    AMoAdLogger.shared().logging = true
    AMoAdLogger.shared().trace = true
    self.historyView = HistoryView(frame: CGRect.zero)
    self.historyView.delegate = self
    self.view.addSubview(self.historyView)
    // Do any additional setup after loading the view.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  @IBAction func onEnvSegmentalControlChanged(_ sender: UISegmentedControl) {
    AMoAdView.setEnvStaging(sender.selectedSegmentIndex == 1)
  }

  @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
    let frame = CGRect(x: self.sidTextField.frame.origin.x,
                       y: self.sidTextField.frame.origin.y + self.sidTextField.frame.height,
                       width: self.sidTextField.frame.width,
                       height: 0)
    self.historyView.show(frame: frame, histories: self.getHistory(viewName: self.viewName))
  }

  @IBAction func onInputDone(_ sender: UITextField) {
    sender.endEditing(true)
    self.historyView.hide()
  }

  @IBAction func loadButtonTapped(_ sender: UIButton) {
    guard let sid = self.sidTextField.text else {
      self.showAlert(message: "sidを入力してください")
      return
    }

    addHistory(viewName: viewName, sid: sid)

    if (self.bannerView != nil) {
      self.bannerView!.removeFromSuperview()
    }

    guard let banner = self.initAd(sid: sid, size: CGSize(width: 320.0, height: 50.0)) else {
      self.showAlert(message: "バナーの作成に失敗しました。")
      return
    }
    self.bannerView = banner
    self.bannerView!.delegate = self
    self.bannerView!.sid = sid

    self.view.addSubview(self.bannerView!)
  }

  func initAd(sid: String, size: CGSize) -> AMoAdView? {
    let frame = CGRect(x: (self.view.bounds.width - size.width) / 2,
                       y: self.logView.frame.maxY + 10.0,
                       width: size.width,
                       height: size.height)
    let banner = AMoAdView(frame: frame)
    return banner
  }
}

extension BannerViewController: AMoAdViewDelegate {
  func aMoAdViewDidReceiveAd(_ amoadView: AMoAdView!) {
    self.addLog(message: "広告を受信しました", view: self.logView)
  }
  func aMoAdViewDidFail(toReceiveAd amoadView: AMoAdView!, error: Error!) {
    self.addLog(message: "広告の受信に失敗しました", view: self.logView)
  }
  func aMoAdViewDidReceiveEmptyAd(_ amoadView: AMoAdView!) {
    self.addLog(message: "表示できる広告がありませんでした", view: self.logView)
  }
  func aMoAdViewDidClick(_ amoadView: AMoAdView!) {
    self.addLog(message: "広告をタップしました", view: self.logView)
  }
}

extension BannerViewController: HistoryViewDelegate {
  func onSelected(text: String) {
    self.sidTextField.text = text
    self.historyView.hide()
  }
}
