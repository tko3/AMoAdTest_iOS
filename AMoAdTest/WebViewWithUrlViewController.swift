//
//  WebViewViewController.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import WebKit

class WebViewWithUrlViewController: UIViewController {

  @IBOutlet var urlTextField: UITextField!
  @IBOutlet var webViewContainer: UIView!
  @IBOutlet var logView: UITextView!
  private var webView: WKWebView!
  private var historyView: HistoryView!

  private var viewName = String(describing: WebViewWithUrlViewController.self)

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
    let frame = CGRect(x: self.urlTextField.frame.origin.x,
                       y: self.urlTextField.frame.origin.y + self.urlTextField.frame.height,
                       width: self.urlTextField.frame.width,
                       height: 0)
    self.historyView.show(frame: frame, histories: self.getHistory(viewName: self.viewName))
  }

  @IBAction func onInputDone(_ sender: UITextField) {
    sender.endEditing(true)
    self.historyView.hide()
  }

  @IBAction func loadButtonTapped(_ sender: UIButton) {
    guard let urlText = self.urlTextField.text, let url = URL(string: urlText) else {
      self.showAlert(message: "正しいURLを指定してください")
      return
    }
    addHistory(viewName: viewName, sid: urlText)
    self.webView.load(URLRequest(url: url))
  }

}

// MARK: - WKNavigationDelegate
extension WebViewWithUrlViewController: WKNavigationDelegate {
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
extension WebViewWithUrlViewController: HistoryViewDelegate {
  func onSelected(text: String) {
    self.urlTextField.text = text
    self.historyView.hide()
  }
}
