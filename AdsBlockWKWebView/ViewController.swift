//
// ViewController.swift
// AdsBlockWKWebView
//
// Created by Wolfgang Weinmann on 2019/12/31.
// Copyright © 2019 Wolfgang Weinmann.
//

import UIKit
import WebKit

fileprivate let ruleId1 = "MyRuleID 001"
fileprivate let ruleId2 = "MyRuleID 002"

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate {
  
  var webview: WKWebView!
  var urlField: UITextField!
  var button: UIButton!
  var lb: UILabel!
  
  var url: URL!
  var defaultUserAgent: String = "default"
  
  var insetT: CGFloat = 0
  var insetB: CGFloat = 0
  var insetL: CGFloat = 0
  var insetR: CGFloat = 0
  
  var counter: Int = 0
  
  //var shouldHideHomeIndicator = false
  override func prefersHomeIndicatorAutoHidden() -> Bool {
    //return shouldHideHomeIndicator
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    view.addSubview(button)
  }
  
  @objc func buttonClicked() {
    button.removeFromSuperview()
    urlField.resignFirstResponder()
    changeUserAgent()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    button.removeFromSuperview()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    button.removeFromSuperview()
    textField.resignFirstResponder()
    
    let alert = UIAlertController(title: "Alert", message: defaultUserAgent + " " + webview.url!.absoluteString, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
    if !(textField.text!.hasPrefix("https://") || textField.text!.hasPrefix("http://") || textField.text!.isEmpty) {
      textField.text = "https://" + textField.text!
    }
    if !(textField.text!.isEmpty) {
      url = URL(string: textField.text!)
      startLoading()
    }
    
    lb.text = lb.text! + " " + textField.text!
    adjustLabel()
    return true
  }
  
  
    private func adjustLabel() {
        //if insetL + insetR > 42 {
            //lb.frame.size.width = self.view.frame.width - insetL - insetR
        //} else {
            //lb.frame.size.width = self.view.frame.width - 42
        //}
        
        lb.frame.size.width = self.view.frame.width
        lb.sizeToFit()
        
        if lb.frame.size.width > self.view.frame.width - insetL - insetR {
            lb.frame.size.width = self.view.frame.width - insetL - insetR
        } else if lb.frame.size.width > self.view.frame.width - 42 {
            lb.frame.size.width = self.view.frame.width - 42
        }
        
        lb.frame.origin.x = (self.view.frame.width - lb.frame.width) / 2
        lb.frame.origin.y = self.view.frame.height - insetB
        lb.textAlignment = .center
    }
    
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        //if #available(iOS 11.0, *) {
        insetT = self.view.safeAreaInsets.top
        insetB = self.view.safeAreaInsets.bottom
        insetL = self.view.safeAreaInsets.left
        insetR = self.view.safeAreaInsets.right
        //}
        
        //lb.text = lb.text! + "_dc_"
        //lb.text = "log: \(insetT) \(insetB) \(insetL) \(insetR) \(counter)"
        //adjustLabel()
        
        //self.shouldHideHomeIndicator = true
        //self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      urlField.frame.origin.x = insetL
      urlField.frame.origin.y = insetT + 5
      urlField.frame.size.width = self.view.frame.width - insetL - insetR
      urlField.frame.size.height = 30
      if insetL == 0 {
        urlField.frame.origin.x = 5
        urlField.frame.size.width -= 5
      }
      if insetR == 0 {
        urlField.frame.size.width -= 5
      }
      if button.isDescendant(of: self.view) {
        urlField.frame.size.width -= 85
      }
      
      //button.frame = CGRect(x: 100, y: 400, width: 100, height: 50)
      button.frame.origin.x = insetL + urlField.frame.size.width + 5
      //button.frame.origin.y = insetT + 10 + urlField.frame.size.height
      button.frame.origin.y = insetT + 5
      button.frame.size.width = 80
      button.frame.size.height = 30
      if insetL == 0 {
        button.frame.origin.x += 5
      }
      
      webview.frame.origin.x = insetL
      webview.frame.origin.y = insetT + urlField.frame.size.height + 10
      webview.frame.size.width = self.view.frame.width - insetL - insetR
      webview.frame.size.height = self.view.frame.height - insetT - insetB - urlField.frame.size.height - 10
      
      lb.text = "log: \(insetT) \(insetB) \(insetL) \(insetR) \(counter)"
      if (view.frame.width > view.frame.height) {
        lb.text = lb.text! + " ls"
      } else {
        lb.text = lb.text! + " pt"
      }
      adjustLabel()
    }
    
    
    //override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    //super.viewWillTransition(to: size, with: coordinator)
    //coordinator.animate(alongsideTransition: nil) { [unowned self] _ in
    
        //if UIDevice.current.orientation.isLandscape {
            //lb.text = "log: ls"
            
            //urlField.leftAnchor.constraint.isActive = false
            //urlField.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0.0).isActive = true
            //self.view.layoutIfNeeded()
        //} else {
            //lb.text = "log: pt"
            
            //urlField.leftAnchor.constraint.isActive = false
            //urlField.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 5.0).isActive = true
            //self.view.layoutIfNeeded()
        //}
    //}
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        UserDefaults.standard.register(defaults: [
            ruleId1 : false,
            ruleId2 : false
            ])
        UserDefaults.standard.synchronize()
        
        webview = WKWebView(frame: CGRect.zero)
        //webview = WKWebView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height - 200))
        
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        view.addSubview(webview)
        webview.frame = view.bounds
        
        counter += 1
        
        lb = UILabel(frame: CGRect.zero)
        //lb.textAlignment = .center
        lb.font = lb.font.withSize(12)
        lb.backgroundColor = .gray
        lb.numberOfLines = 0
        view.addSubview(lb)
        
        urlField = UITextField(frame: CGRect.zero)
        //urlField = UITextField()
        urlField.placeholder = "Type your Address"
        urlField.font = UIFont.systemFont(ofSize: 15)
        urlField.backgroundColor = .white
        //urlField.borderStyle = UITextField.BorderStyle.roundedRect
        //urlField.layer.borderWidth = 0
        
        urlField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        urlField.leftViewMode = .always
        
        urlField.layer.cornerRadius = 5
        urlField.clipsToBounds = true
        urlField.autocapitalizationType = .none
        urlField.autocorrectionType = UITextAutocorrectionType.no
        urlField.keyboardType = UIKeyboardType.webSearch
        urlField.returnKeyType = UIReturnKeyType.done
        urlField.clearButtonMode = UITextField.ViewMode.whileEditing
        urlField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        urlField.delegate = self
        view.addSubview(urlField)
        
    //urlField.translatesAutoresizingMaskIntoConstraints = false
    //urlField.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 5.0).isActive = true
    //urlField.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -5.0).isActive = true
    //urlField.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 5.0).isActive = true
    //urlField.bottomAnchor.constraint(equalTo: urlField.topAnchor, constant: 30.0).isActive = true
    
    
        button = UIButton(frame: CGRect.zero)
        //button.frame = CGRectMake(15, -50, 300, 500)
        button.backgroundColor = .gray
        
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        
        url = URL(string: "https://www.google.com")
        
        if #available(iOS 11, *) {
            let group = DispatchGroup()
            group.enter()
            setupContentBlockFromStringLiteral {
                group.leave()
            }
            group.enter()
            setupContentBlockFromFile {
                group.leave()
            }
            group.notify(queue: .main, execute: { [weak self] in
                self?.startLoading()
            })
        } else {
            alertToUseIOS11()
            startLoading()
        }
    }
  
  private func changeUserAgent() {
    if defaultUserAgent == "default" {
      webview.evaluateJavaScript("navigator.userAgent") { (result, error) in
        self.defaultUserAgent = result as! String
        self.webview.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Safari/605.1.15"
        //self.webview.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36"
        self.webview.reload()
      }
    } else {
      webview.customUserAgent = defaultUserAgent
      defaultUserAgent = "default"
      webview.reload()
    }
  }
  
  private func startLoading() {
    let request = URLRequest(url: url)
    
    //request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
    //request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    webview.load(request)
  }
  
  func webview(_ webview: WKWebView, didFinish navigation: WKNavigation!) {
    
    let alert = UIAlertController(title: "Alert", message: defaultUserAgent + " " + webview.url!.absoluteString, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
    urlField.text = webview.url!.absoluteString
  }
  
  
    @available(iOS 11.0, *)
    private func setupContentBlockFromStringLiteral(_ completion: (() -> Void)?) {
        // Swift 4  Multi-line string literals
        let jsonString = """
[{
  "trigger": {
    "url-filter": "://googleads\\\\.g\\\\.doubleclick\\\\.net.*"
  },
  "action": {
    "type": "block"
  }
}]
"""
        if UserDefaults.standard.bool(forKey: ruleId1) {
            // list should already be compiled
            WKContentRuleListStore.default().lookUpContentRuleList(forIdentifier: ruleId1) { [weak self] (contentRuleList, error) in
                if let error = error {
                    self?.printRuleListError(error, text: "lookup json string literal")
                    UserDefaults.standard.set(false, forKey: ruleId1)
                    self?.setupContentBlockFromStringLiteral(completion)
                    return
                }
                if let list = contentRuleList {
                    self?.webview.configuration.userContentController.add(list)
                    completion?()
                }
            }
        }
        else {
            WKContentRuleListStore.default().compileContentRuleList(forIdentifier: ruleId1, encodedContentRuleList: jsonString) { [weak self] (contentRuleList: WKContentRuleList?, error: Error?) in
                if let error = error {
                    self?.printRuleListError(error, text: "compile json string literal")
                    return
                }
                if let list = contentRuleList {
                    self?.webview.configuration.userContentController.add(list)
                    UserDefaults.standard.set(true, forKey: ruleId1)
                    completion?()
                }
            }
        }
    }
    
    @available(iOS 11.0, *)
    private func setupContentBlockFromFile(_ completion: (() -> Void)?) {
        if UserDefaults.standard.bool(forKey: ruleId2) {
            WKContentRuleListStore.default().lookUpContentRuleList(forIdentifier: ruleId2) { [weak self] (contentRuleList, error) in
                if let error = error {
                    self?.printRuleListError(error, text: "lookup json file")
                    UserDefaults.standard.set(false, forKey: ruleId2)
                    self?.setupContentBlockFromFile(completion)
                    return
                }
                if let list = contentRuleList {
                    self?.webview.configuration.userContentController.add(list)
                    completion?()
                }
            }
        }
        else {
            if let jsonFilePath = Bundle.main.path(forResource: "adaway.json", ofType: nil),
                let jsonFileContent = try? String(contentsOfFile: jsonFilePath, encoding: String.Encoding.utf8) {
                WKContentRuleListStore.default().compileContentRuleList(forIdentifier: ruleId2, encodedContentRuleList: jsonFileContent) { [weak self] (contentRuleList, error) in
                    if let error = error {
                        self?.printRuleListError(error, text: "compile json file")
                        return
                    }
                    if let list = contentRuleList {
                        self?.webview.configuration.userContentController.add(list)
                        UserDefaults.standard.set(true, forKey: ruleId2)
                        completion?()
                    }
                }
            }
        }
    }
    
    @available(iOS 11.0, *)
    private func resetContentRuleList() {
        let config = webview.configuration
        config.userContentController.removeAllContentRuleLists()
    }
    
    private func alertToUseIOS11() {
        let title: String? = "Use iOS 11 and above for ads-blocking."
        let message: String? = nil
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        DispatchQueue.main.async { [unowned self] in
            self.view.window?.rootViewController?.present(alertController, animated: true, completion: {
                
            })
        }
    }
    
    
    @available(iOS 11.0, *)
    private func printRuleListError(_ error: Error, text: String = "") {
        guard let wkerror = error as? WKError else {
            print("\(text) \(type(of: self)) \(#function): \(error)")
            return
        }
        switch wkerror.code {
        case WKError.contentRuleListStoreLookUpFailed:
            print("\(text) WKError.contentRuleListStoreLookUpFailed: \(wkerror)")
        case WKError.contentRuleListStoreCompileFailed:
            print("\(text) WKError.contentRuleListStoreCompileFailed: \(wkerror)")
        case WKError.contentRuleListStoreRemoveFailed:
            print("\(text) WKError.contentRuleListStoreRemoveFailed: \(wkerror)")
        case WKError.contentRuleListStoreVersionMismatch:
            print("\(text) WKError.contentRuleListStoreVersionMismatch: \(wkerror)")
        default:
            print("\(text) other WKError \(type(of: self)) \(#function):\(wkerror) \(wkerror)")
            break
        }
    }
    
    // Just for invalidating target="_blank"
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else {
            return nil
        }
        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame else {
            webView.load(URLRequest(url: url))
            return nil
        }
        return nil
    }
    

}

