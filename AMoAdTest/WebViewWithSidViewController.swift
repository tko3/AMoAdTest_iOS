//
//  WebViewWithSidViewController.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/11.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import WebKit
import AdSupport

class WebViewWithSidViewController: UIViewController {

  @IBOutlet var sidTextField: UITextField!
  @IBOutlet var envSeg: UISegmentedControl!
  @IBOutlet var tagSeg: UISegmentedControl!
  @IBOutlet var useIdfaSeg: UISegmentedControl!
  @IBOutlet var webViewContainer: UIView!
  @IBOutlet var logView: UITextView!
  private var webView: WKWebView!
  private var historyView: HistoryView!

  private let baseUrl = URL(string: "https://www.amoad.com")
  private var viewName = String(describing: WebViewWithSidViewController.self)

  override func viewDidLoad() {
    super.viewDidLoad()
    initWebview()
    self.webView.navigationDelegate = self
    self.historyView = HistoryView(frame: CGRect.zero)
    self.historyView.delegate = self
    self.view.addSubview(self.historyView)
  }

  private func initWebview() {
    let webConfiguration = WKWebViewConfiguration()
    let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.webViewContainer.frame.size.height))
    self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
    self.webViewContainer.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
    webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
    webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
    webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor).isActive = true
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
    var dataIdfa = ""
    if let idfa = self.getIDFA() {
      dataIdfa = "data-sid='\(idfa)'"
    }
    let domain = (self.envSeg.selectedSegmentIndex == 0) ? "j.amoad.com" : "stg-j.amoad.net"
    let tag = (self.tagSeg.selectedSegmentIndex == 0) ?
    "<div class='amoad_frame sid_\(sid) container_div color_#0000CC-#444444-#FFFFFF-#0000FF-#009900 sp wv' \(dataIdfa)></div><script src='https://\(domain)/js/aa.js' type='text/javascript' charset='utf-8'></script>" :
    "<div class='amoad_native' data-sid='\(sid)' \(dataIdfa)></div><script src='https://\(domain)/js/n.js' type='text/javascript' charset='utf-8'></script>"

    let html = "<!doctype html><html lang='ja'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1.0,user-scalable=no,shrink-to-fit=no'></head><body style='margin: 0; padding: 0'>\(tag)</body></html>"

    self.webView.loadHTMLString(html, baseURL: baseUrl)
  }

  private func getIDFA() -> String? {
    if (!ASIdentifierManager.shared().isAdvertisingTrackingEnabled) {
      return nil
    }
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
  }

}

// MARK: - WKNavigationDelegate
extension WebViewWithSidViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated {
      self.addLog(message: "リンクをクリックしました", view: self.logView)
      if let url = navigationAction.request.url {
        UIApplication.shared.openURL(url)
        //UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}

// MARK: - HistoryViewDelegate
extension WebViewWithSidViewController: HistoryViewDelegate {
  func onSelected(text: String) {
    self.sidTextField.text = text
    self.historyView.hide()
  }
}
