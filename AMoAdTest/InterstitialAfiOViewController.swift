//
//  InterstitialAfiOViewController.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import AMoAd

class InterstitialAfiOViewController: UIViewController {

  @IBOutlet var sidTextField: UITextField!
  @IBOutlet var logView: UITextView!
  private var historyView: HistoryView!

  private var interstitialAfio: AMoAdInterstitialVideo?
  private var sid: String?
  private var viewName = String(describing: InterstitialAfiOViewController.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    AMoAdLogger.shared().logging = true
    AMoAdLogger.shared().trace = true
    self.historyView = HistoryView(frame: CGRect.zero)
    self.historyView.delegate = self
    self.view.addSubview(self.historyView)
  }

  @IBAction func onEnvSegmentalControlChanged(_ sender: UISegmentedControl) {
    AMoAdNativeViewManager.shared()?.setEnvStaging(sender.selectedSegmentIndex == 1)
  }

  @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
    let frame = CGRect(x: self.sidTextField.frame.origin.x,
                       y: self.sidTextField.frame.origin.y + self.sidTextField.frame.height,
                       width: self.sidTextField.frame.width,
                       height: 0)
    self.historyView.show(frame: frame, histories: self.getHistory(viewName: self.viewName))
  }

  @IBAction func onInputDone(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  @IBAction func loadButtonTapped(_ sender: UIButton) {
    guard let sid = sidTextField.text else {
      self.showAlert(message: "sidを入力してください")
      return
    }
    addHistory(viewName: viewName, sid: sid)
    self.sid = sid

    interstitialAfio = AMoAdInterstitialVideo.sharedInstance(withSid: sid, tag: "")
    interstitialAfio?.delegate = self
    interstitialAfio?.load()

  }

  @IBAction func showButtonTapped(_ sender: UIButton) {
    guard let afio = self.interstitialAfio else {
      self.showAlert(message: "広告が読み込まれていません。広告を読み込みボタンを押下して広告の読み込みを行なってください")
      return
    }
    if (!afio.isLoaded) {
      self.showAlert(message: "広告の読み込みが完了してません")
      return
    }
    afio.show()
  }
}

// MARK: - AMoAdInterstitialVideoDelegate
extension InterstitialAfiOViewController: AMoAdInterstitialVideoDelegate {
  func amoadInterstitialVideo(_ amoadInterstitialVideo: AMoAdInterstitialVideo!, didLoadAd result: AMoAdResult) {
    switch (result) {
    case .success:
      self.addLog(message: "広告の読み込みが完了しました", view: self.logView)
      break
    case .failure:
      self.showAlert(message: "広告の読み込みに失敗しました" )
      break
    case .empty:
      self.showAlert(message: "表示できる広告がありませんでした")
      break
    }
  }
  func amoadInterstitialVideoDidStart(_ amoadInterstitialVideo: AMoAdInterstitialVideo!) {
    self.addLog(message: "動画の再生を開始しました", view: self.logView)
  }
  func amoadInterstitialVideoDidComplete(_ amoadInterstitialVideo: AMoAdInterstitialVideo!) {
    self.addLog(message: "動画の再生が完了しました", view: self.logView)
  }
  func amoadInterstitialVideoDidFailToPlay(_ amoadInterstitialVideo: AMoAdInterstitialVideo!) {
    self.addLog(message: "動画の再生を開始しました", view: self.logView)
  }
  func amoadInterstitialVideoDidShow(_ amoadInterstitialVideo: AMoAdInterstitialVideo!) {
    self.addLog(message: "広告の表示を開始しました", view: self.logView)
  }
  func amoadInterstitialVideoWillDismiss(_ amoadInterstitialVideo: AMoAdInterstitialVideo!) {
    self.addLog(message: "広告の表示が終了しました", view: self.logView)
  }
  func amoadInterstitialVideoDidClickAd(_ amoadInterstitialVideo: AMoAdInterstitialVideo!) {
    self.addLog(message: "広告をタップしました", view: self.logView)
  }
}

// MARK: - HistoryViewDelegate
extension InterstitialAfiOViewController: HistoryViewDelegate {
  func onSelected(text: String) {
    self.sidTextField.text = text
    self.historyView.hide()
  }
}
