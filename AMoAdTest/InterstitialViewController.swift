//
//  InterstitialViewController.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import AMoAd

class InterstitialViewController: UIViewController {

  @IBOutlet var sidTextField: UITextField!
  @IBOutlet var logView: UITextView!
  private var historyView: HistoryView!

  private var sid: String?
  
  private var viewName = String(describing: InterstitialViewController.self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    AMoAdLogger.logLevel = .debug
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

  func initAd(sid: String) {
    self.sid = sid
    AMoAdInterstitial.registerAd(sid: sid)
    AMoAdInterstitial.setPortraitPanel(sid: sid, image: UIImage.init(named: "user_panel.png"))
    AMoAdInterstitial.setAutoReload(sid: sid, isAutoReload: true)
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
    self.initAd(sid: sid)

    AMoAdInterstitial.loadAd(sid: self.sid!) { (id, result, error) in
      switch (result) {
      case .success:
        self.addLog(message: "広告の読み込みが完了しました", view: self.logView)
        break
      case .failure:
        guard let e = error else {
          self.showAlert(message: "広告の読み込みに失敗しました")
          return
        }
        self.showAlert(message: "広告の読み込みに失敗しました。" + e.localizedDescription)
        break
      case .empty:
        self.showAlert(message: "表示できる広告がありませんでした")
        break
      }
    }
  }

  @IBAction func showButtonTapped(_ sender: UIButton) {
    guard let sid = self.sid else {
      self.showAlert(message: "sidが指定されていません")
      return
    }
    if (!AMoAdInterstitial.isLoadedAd(sid: sid)) {
      self.showAlert(message: "広告の読み込みが完了していません")
      return
    }
    
    AMoAdInterstitial.showAd(sid: sid) { (id, result, error) in
      switch (result) {
      case .click:
        self.addLog(message: "リンクボタンがクリックされたので閉じました", view: self.logView)
      case .close:
        self.addLog(message: "閉じるボタンがクリックされたので閉じました", view: self.logView)
      case .duplicated:
        self.addLog(message: "既に開かれているので開きませんでした", view: self.logView)
      case .closeFromApp:
        self.addLog(message: "アプリから閉じられました", view: self.logView)
      case .failure:
        guard let e = error else {
          self.showAlert(message: "広告の取得に失敗しました")
          return
        }
        self.showAlert(message: "広告の取得に失敗しました。" + e.localizedDescription)
        break
      }
    }
  }
}

extension InterstitialViewController: HistoryViewDelegate {
  func onSelected(text: String) {
    self.sidTextField.text = text
    self.historyView.hide()
  }
}
