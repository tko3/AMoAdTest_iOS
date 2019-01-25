//
//  InfeedAfiOViewController
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import AMoAd

class InfeedAfiOViewController: UIViewController {

  @IBOutlet var sidTextField: UITextField!
  @IBOutlet var logView: UITextView!
  @IBOutlet weak var adView: UIView!
  private var afioView: UIView?
  private var historyView: HistoryView!

  private var sid: String?
  private var viewName = String(describing: InfeedAfiOViewController.self)
  
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

  func createAfioView() -> UIView {
    guard let afioView = Bundle.main.loadNibNamed("AfiOView", owner: nil, options: nil)?.first as? UIView else {
      return UIView()
    }

    afioView.translatesAutoresizingMaskIntoConstraints = false
    self.layoutAfioView(view: afioView)
    return afioView
  }
  func layoutAfioView(view: UIView) {
    self.adView.addSubview(view)
    self.adView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.adView, attribute: .centerX, multiplier: 1, constant: 0))
    self.adView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.adView, attribute: .centerY, multiplier: 1, constant: 0))
    self.adView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .width,   relatedBy: .equal, toItem: self.adView, attribute: .width,   multiplier: 1, constant: 0))
    self.adView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .height,  relatedBy: .equal, toItem: self.adView, attribute: .height,  multiplier: 1, constant: 0))
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
    sender.endEditing(true)
    self.historyView.hide()
  }

  @IBAction func loadButtonTapped(_ sender: UIButton) {
    guard let sid = sidTextField.text else {
      self.showAlert(message: "sidを入力してください")
      return
    }

    if (self.afioView != nil) {
      AMoAdNativeViewManager.shared().clearAd(withSid: self.sid, tag: "")
      self.afioView?.removeFromSuperview()
    }
    addHistory(viewName: viewName, sid: sid)
    self.afioView = self.createAfioView()
    self.sid = sid
    AMoAdNativeViewManager.shared()?.prepareAd(withSid: sid)
    AMoAdNativeViewManager.shared().renderAd(withSid: sid, tag: "", view: self.afioView!, delegate: self)
    guard let videoView = self.afioView!.viewWithTag(7) as? AMoAdNativeMainVideoView else { return }
    videoView.delegate = self
    if let link = self.afioView!.viewWithTag(6) as? UILabel {
      link.isUserInteractionEnabled = true
    }
  }
}

extension InfeedAfiOViewController: AMoAdNativeAppDelegate {
  func amoadNativeDidReceive(_ sid: String!, tag: String!, view: UIView!, state: AMoAdResult) {
    switch (state) {
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

  func amoadNativeIconDidReceive(_ sid: String!, tag: String!, view: UIView!, state: AMoAdResult) {
    switch (state) {
    case .success:
      self.addLog(message: "アイコン画像の読み込みが完了しました", view: self.logView)
      break
    case .failure:
      self.showAlert(message: "アイコン画像の読み込みに失敗しました" )
      break
    case .empty:
      self.showAlert(message: "表示できる広告がありませんでした")
      break
    }
  }

  func amoadNativeImageDidReceive(_ sid: String!, tag: String!, view: UIView!, state: AMoAdResult) {
    switch (state) {
    case .success:
      self.addLog(message: "メイン画像の読み込みが完了しました", view: self.logView)
      break
    case .failure:
      self.showAlert(message: "メイン画像の読み込みに失敗しました" )
      break
    case .empty:
      self.showAlert(message: "表示できる広告がありませんでした")
      break
    }
  }
  func amoadNativeDidClick(_ sid: String!, tag: String!, view: UIView!) {
    self.showAlert(message: "広告をタップしました")
  }
}

extension InfeedAfiOViewController: AMoAdNativeVideoAppDelegate {
  func amoadNativeVideoDidStart(_ amoadNativeMainVideoView: UIView!) {
    self.addLog(message: "動画の再生を開始しました", view: self.logView)
  }

  func amoadNativeVideoDidComplete(_ amoadNativeMainVideoView: UIView!) {
    self.addLog(message: "動画の再生が完了しました", view: self.logView)
  }

  func amoadNativeVideoDidFailToPlay(_ amoadNativeMainVideoView: UIView!) {
    self.showAlert(message: "動画の再生に失敗しました")
  }
}

extension InfeedAfiOViewController: HistoryViewDelegate {
  func onSelected(text: String) {
    self.sidTextField.text = text
    self.historyView.hide()
  }
}
