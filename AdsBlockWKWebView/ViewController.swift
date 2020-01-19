// ViewController.swift
// AdsBlockWKWebView
// Created by Wolfgang Weinmann on 2019/12/31.
// Copyright © 2019 Wolfgang Weinmann.

import UIKit
import WebKit

import AVFoundation
import AVKit

fileprivate let ruleId1 = "MyRuleID 001"
fileprivate let ruleId2 = "MyRuleID 002"


//let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")
//let player = AVPlayer(url: videoURL!)
//let playerViewController = AVPlayerViewController()


class WebViewHistory: WKBackForwardList {
  /* Solution 1: return nil, discarding what is in backList & forwardList 
  override var backItem: WKBackForwardListItem? {
    return nil
  }
  override var forwardItem: WKBackForwardListItem? {
    return nil
  }*/
  /* Solution 2: override backList and forwardList to add a setter */
  var myBackList = [WKBackForwardListItem]()
  override var backList: [WKBackForwardListItem] {
    get {
      return myBackList
    }
    set(list) {
      myBackList = list
    }
  }
  func clearBackList() {
    backList.removeAll()
  }
}


class WebView: WKWebView {
  
  var history: WebViewHistory
  override var backForwardList: WebViewHistory {
    return history
  }
  //var history: String
  
  //init(frame: CGRect) {
  init(frame: CGRect, history: WebViewHistory) {
    let conf = WKWebViewConfiguration()
    self.history = history
    super.init(frame: frame, configuration: conf)
  }
  required init?(coder decoder: NSCoder) {
    fatalError()
  }
}


/*
class WebView2: WKWebView {

    var history: WebViewHistory

    init(frame: CGRect, configuration: WKWebViewConfiguration, history: WebViewHistory) {
        self.history = history
        super.init(frame: frame, configuration: configuration)
    }
    
    //Not sure about the best way to handle this part, it was just required for the code to compile...
    
    //required init?(coder: NSCoder) {
        //self.history = WebViewHistory()
        //super.init(coder: coder)
    //}
    
    override var backForwardList: WebViewHistory {
        return history
    }
    
    required init?(coder: NSCoder) {

        if let history = coder.decodeObject(forKey: "history") as? WebViewHistory {
            self.history = history
        }
        else {
            history = WebViewHistory()
        }

        super.init(coder: coder)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(history, forKey: "history")
    }
    
}
*/


class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
  var webview: WKWebView!
  var urlField: UITextField!
  var button: UIButton!
  var lb: UILabel!
  
  var tableView: UITableView!
  var origArray: Array<String> = ["https://google.com"]
  var array: Array<String> = []
  
  //var url: URL!
  var url: String!
  var defaultUserAgent: String = "default"
  
  var restoreIndex: Int = 0
  var restoreIndexLast: Int = 0
  var restoreUrls: Array<String> = ["https://google.com"]
  var restorePosition: Int = 0
  //var bfarray: Array<String> = []
  var webview2: WebView!
  var webview3: WebView!
  var webviewConfig: WKWebViewConfiguration!
  
  var insetT: CGFloat = 0
  var insetB: CGFloat = 0
  var insetL: CGFloat = 0
  var insetR: CGFloat = 0
  
  var lastDeviceOrientation: String = "initial"
  
  var counter: Int = 0
  
  var shouldHideHomeIndicator = false
  override func prefersHomeIndicatorAutoHidden() -> Bool {
    return shouldHideHomeIndicator
    //return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    switch textField {
      case urlField:
        textField.frame.size.width -= 85
        button.frame.origin.x -= 85
        view.addSubview(button)
        textField.selectAll(nil)
      default:
        break
    }
  }
  
  @objc func buttonClicked() {
    urlField.endEditing(true)
    
    /*let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
let player = AVPlayer(url: videoURL!)
let playerLayer = AVPlayerLayer(player: player)
playerLayer.frame = self.view.bounds
self.view.layer.addSublayer(playerLayer)
player.play()*/
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    /*delegate.playerViewController.player = delegate.player
    self.present(delegate.playerViewController, animated: true) {
    delegate.playerViewController.player!.play()
}*/
    
    
    func findAVPlayerViewController(controller: UIViewController) -> AVPlayerViewController? {
  if controller is AVPlayerViewController {
    lb.text = lb.text! + " a2"
    adjustLabel()
    return controller as? AVPlayerViewController
  } else {
    lb.text = lb.text! + " a3"
    adjustLabel()
    for subcontroller in controller.childViewControllers {
      lb.text = lb.text! + " a4"
      adjustLabel()
      if let result = findAVPlayerViewController(controller: subcontroller) {
        lb.text = lb.text! + " a5"
        adjustLabel()
        return result
      }
    }
  }
  return nil
}
    
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
    lb.text = lb.text! + " a1 \((UIApplication.shared.keyWindow?.rootViewController)!)"
    adjustLabel()
    if let avPlayerViewController = findAVPlayerViewController(controller: rootController) {
      lb.text = lb.text! + " aX \(avPlayerViewController.player!)"
      adjustLabel()
    }
  }
    
    /*var viewlist = "list:"
    func findViewWithAVPlayerLayer(view: UIView) -> UIView? {
    //if view.layer is AVPlayerLayer {
    if view.layer.isKind(of:AVPlayerLayer.self) {
        lb.text = lb.text! + " a1"
        adjustLabel()
        return view
    }
    
    if let sublayers = view.layer.sublayers {
    for layer in sublayers {
    if !(layer is CALayer) {
        viewlist = viewlist + " a2:\(layer)"
        }
    }
}
    
    for v in view.subviews {
    if !(v.layer is CALayer) {
        viewlist = viewlist + " a3:\(v.layer)"
        }
        if let found = findViewWithAVPlayerLayer(view: v) {
            lb.text = lb.text! + " a4"
            adjustLabel()
            return found
        }
    }
    return nil
}
    
    if let viewWithAVPlayerLayer = findViewWithAVPlayerLayer(view: self.view) {
      lb.text = lb.text! + " aX"
      adjustLabel()
    }
    showAlert(message: viewlist)*/
    
    
    let deviceToken = delegate.sesscat
    lb.text = lb.text! + " \(deviceToken)"
    adjustLabel()
    
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    
    let file = Bundle.main.path(forResource: "Info", ofType: "plist")!
    let p = URL(fileURLWithPath: file)
    let text = try? String(contentsOf: p)
    
    //let blitem = webview2.backForwardList.item(at: 0)!.url.absoluteString
    let blitem = webview2.backForwardList.forwardList.count
    let blcount1 = webview2.backForwardList.backList.count
    webview2.backForwardList.backList.removeAll()
    let blcount2 = webview2.backForwardList.backList.count
    showAlert(message: "\(blitem) \(blcount1)/\(blcount2) \(appVersion!) \(text!)")
    
  }
  
  @objc func buttonPressed(gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
      urlField.endEditing(true)
      changeUserAgent()
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch textField {
      case urlField:
        if let text = textField.text, let textRange = Range(range, in: text) {
          let updatedText = text.replacingCharacters(in: textRange, with: string)
          array.removeAll()
          origArray.forEach { item in
            if item.lowercased().contains(updatedText.lowercased()) {
              array.append(item)
            }
          }
          if updatedText == "&showall" {
            array = origArray
          }
          if !(array.isEmpty) {
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            if !(tableView.isDescendant(of: view)) {
              view.addSubview(tableView)
            }
          }
          if array.isEmpty {
            if tableView.isDescendant(of: view) {
              tableView.removeFromSuperview()
            }
          }
        }
      default:
        break
    }
    return true
  }
  
  //alertToUseIOS11()
  //var origArray: Array<String> = ["https://google.com","https://orf.at","https://derstandard.at","https://welt.de","https://willhaben.at","https://www.aktienfahrplan.com/plugins/rippletools/ripplenode.cgi"]
  //array.insert(item, at: 0)
  //array = array.sorted(by: >)
  //array = array.reversed()
  //tableView.selectRow(at: nil, animated: false, scrollPosition: .top)
  //tableView.deselectRow(at: indexPath, animated: true)
  //origArray.append(urlField.text!)
  //array.remove(at: indexPath.row)
  //origArray.remove(at: indexPath.row)
  //origArray.remove(at: origArray.index(of: indexPath.row)!)
  //origArray.append(textField.text!)
  //if !(array.contains(textField.text!)) {}
  //tableView.beginUpdates()
  //tableView.endUpdates()
  //tableView.deleteRows(at: [indexPath], with: .automatic)
  //if updatedText.isEmpty {
  //array = origArray
  //}
  //if (cell.isHighlighted) {}
  //cell.textLabel!.backgroundColor = .gray
  //cell.textLabel!.layer.backgroundColor = UIColor.gray.cgColor
  //cell.layer.backgroundColor = UIColor.gray.cgColor
  //cell.selectionStyle = .blue
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
    cell.backgroundColor = .clear
    cell.textLabel!.font = UIFont.systemFont(ofSize: 15)
    cell.textLabel!.text = "\(array[indexPath.row])"
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableView.frame.size.height = CGFloat(min(array.count * 30, 185))
    return array.count
  }
  
  func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.contentView.backgroundColor = .gray
    //cell?.backgroundColor = .gray
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    urlField.endEditing(true)
    urlField.text = "\(array[indexPath.row])"
    origArray = origArray.filter{$0 != urlField.text!}
    origArray.insert(urlField.text!, at: 0)
    UserDefaults.standard.set(origArray, forKey: "origArray")
    //url = URL(string: urlField.text!)
    url = urlField.text!
    startLoading()
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      origArray = origArray.filter{$0 != array[indexPath.row]}
      UserDefaults.standard.set(origArray, forKey: "origArray")
      array = array.filter{$0 != array[indexPath.row]}
      tableView.reloadData()
    }
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    switch textField {
      case urlField:
        if tableView.isDescendant(of: view) {
          tableView.removeFromSuperview()
        }
        lb.text = "log:"
        adjustLabel()
      default:
        break
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
      case urlField:
        if tableView.isDescendant(of: view) {
          tableView.removeFromSuperview()
        }
        textField.selectedTextRange = nil
        button.removeFromSuperview()
        button.frame.origin.x += 85
        textField.frame.size.width += 85
      default:
        break
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
      case urlField:
        textField.endEditing(true)
        //if !(textField.text!.hasPrefix("https://") || textField.text!.hasPrefix("http://") || textField.text!.isEmpty) {
          //textField.text = "https://" + textField.text!
        //}
        if !(textField.text!.isEmpty) {
          origArray = origArray.filter{$0 != textField.text!}
          origArray.insert(textField.text!, at: 0)
          UserDefaults.standard.set(origArray, forKey: "origArray")
          //url = URL(string: textField.text!)
          url = textField.text!
          startLoading()
        }
        //lb.text = lb.text! + " " + textField.text!
        //adjustLabel()
      default:
        break
    }
    return true
  }
  
  private func showAlert(message: String) {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
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
    super.viewSafeAreaInsetsDidChange()
    insetT = self.view.safeAreaInsets.top
    insetB = self.view.safeAreaInsets.bottom
    insetL = self.view.safeAreaInsets.left
    insetR = self.view.safeAreaInsets.right
    lb.text = lb.text! + " dc"
    adjustLabel()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    var deviceOrientation = "pt"
    if (view.frame.width > view.frame.height) {
      deviceOrientation = "ls"
    }
    
    if !(deviceOrientation == lastDeviceOrientation) {
      
      if !(lastDeviceOrientation == "initial") {
        if deviceOrientation == "pt" {
          shouldHideHomeIndicator = false
        } else {
          shouldHideHomeIndicator = true
        }
        
        if #available(iOS 11, *) {
          setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
        
      }
      
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
      button.frame.origin.y = insetT + 5
      button.frame.size.width = 80
      button.frame.size.height = 30
      if insetL == 0 {
        button.frame.origin.x += 5
      }
      
      tableView.frame.origin.x = insetL
      tableView.frame.origin.y = insetT + urlField.frame.size.height + 10
      tableView.frame.size.width = self.view.frame.width - insetL - insetR
      tableView.frame.size.height = 185
      
      tableView.reloadData()
      
      //tableView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
      
      webview.frame.origin.x = insetL
      webview.frame.origin.y = insetT + urlField.frame.size.height + 10
      webview.frame.size.width = self.view.frame.width - insetL - insetR
      webview.frame.size.height = self.view.frame.height - insetT - insetB - urlField.frame.size.height - 10
      
      webview.frame.origin.y += 200
      webview.frame.size.height -= 200
      
      webview3.frame.origin.x = insetL
      webview3.frame.origin.y = insetT + 5
      webview3.frame.size.width = self.view.frame.width - insetL - insetR
      webview3.frame.size.height = self.view.frame.height - insetT - insetB - 5
      
      lb.text = lb.text! + " \(insetT) \(insetB) \(insetL) \(insetR) \(counter)"
      if (view.frame.width > view.frame.height) {
        //shouldHideHomeIndicator = true
        //if #available(iOS 11, *) {
          //setNeedsUpdateOfHomeIndicatorAutoHidden()
        //}
        lb.text = lb.text! + " ls"
        lastDeviceOrientation = "ls"
      } else {
        //shouldHideHomeIndicator = false
        //if #available(iOS 11, *) {
          //setNeedsUpdateOfHomeIndicatorAutoHidden()
        //}
        lb.text = lb.text! + " pt"
        lastDeviceOrientation = "pt"
      }
      adjustLabel()
      
    }
    
    //if button.isDescendant(of: self.view) {
      //urlField.frame.size.width -= 85
      //button.frame.origin.x -= 85
    //}
    
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if (UserDefaults.standard.object(forKey: "origArray") != nil) {
          origArray = UserDefaults.standard.stringArray(forKey: "origArray") ?? [String]()
        }
        
        //self.view.backgroundColor = .lightGray
        view.backgroundColor = UIColor(white: 0.90, alpha: 1)
        
        UserDefaults.standard.register(defaults: [
            ruleId1 : false,
            ruleId2 : false
            ])
        UserDefaults.standard.synchronize()
        
        webviewConfig = WKWebViewConfiguration()
        //webviewConfig.allowsInlineMediaPlayback = true
        //webviewConfig.mediaTypesRequiringUserActionForPlayback = []
        
        webview = WKWebView(frame: CGRect.zero, configuration: webviewConfig)
        //webview = WKWebView(frame: CGRect.zero)
        //webview = WKWebView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height - 200))
        
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        view.addSubview(webview)
        webview.frame = view.bounds
        
        //webview.isHidden = true
        
        counter += 1
        
        lb = UILabel(frame: CGRect.zero)
        lb.text = "log:"
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
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonClicked))
        //tapGesture.numberOfTapsRequired = 1
        //button.addGestureRecognizer(tapGesture)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonPressed(gesture:)))
        //longPress.minimumPressDuration = 3
        button.addGestureRecognizer(longPress)
        
        tableView = UITableView(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.backgroundColor = .lightGray
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.rowHeight = 30
        //tableView.estimatedRowHeight = 0
        //tableView.estimatedSectionHeaderHeight = 0
        //tableView.estimatedSectionFooterHeight = 0
        //if #available(iOS 11.0, *) {
          //tableView.contentInsetAdjustmentBehavior = .never
        //} else {
          //automaticallyAdjustsScrollViewInsets = false
        //}
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -15)
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -10)
        //tableView.contentSize.width = 100
        //tableView.clipsToBounds = false
        //tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -30)
        tableView.separatorColor = .gray
        //tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        
        if (UserDefaults.standard.object(forKey: "urls") != nil) {
        restoreUrls = UserDefaults.standard.stringArray(forKey: "urls") ?? [String]()
        }
        
        if (UserDefaults.standard.object(forKey: "currentIndexButLast") != nil) {
        restorePosition = UserDefaults.standard.integer(forKey: "currentIndexButLast")
        }
        
        restoreIndexLast = restoreUrls.count - 1
        
        if restoreIndexLast > 0 {
          DispatchQueue.main.async {
            self.askRestore()
          }
        }
        
    webview.load(URLRequest(url: URL(string: restoreUrls[restoreIndex])!))
    
    var bflist = "LASTbflist:"
    restoreUrls.forEach { url in
      //self.webview.load(URLRequest(url: url))
      //DispatchQueue.main.async {
      //self.webview.load(URLRequest(url: URL(string: url)!))
      //}
      bflist = bflist + " " + url
    }
    bflist = bflist + " \(restorePosition)"
    DispatchQueue.main.async {
      //self.showAlert(message: "\(bflist)")
    }
    //lb.text = lb.text! + bflist
    //adjustLabel()
    
    webview3 = WebView(frame: CGRect.zero, history: WebViewHistory())
    webview3.loadHTMLString("<body style='background-color:transparent;'><h1>Loading last Session... \(restoreIndex+1)/\(restoreIndexLast+1)</h1></body>", baseURL: nil)
    webview3.isOpaque = false
    webview3.backgroundColor = .orange
    webview3.scrollView.backgroundColor = .orange
    webview3.scrollView.isScrollEnabled = false
    //webview3.scrollView.bounces = false
    view.addSubview(webview3)
    
    NotificationCenter.default.addObserver(self, selector: #selector(focusNewWindow), name: .UIWindowDidResignKey, object: nil)
    
    
        //url = URL(string: "https://www.google.com")
        url = "https://www.google.com"
        
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
                //self?.startLoading()
            })
        } else {
            alertToUseIOS11()
            startLoading()
        }
    }
  
  
  @objc private func focusNewWindow() {
    if UIApplication.shared.windows.count > 1 && UIApplication.shared.windows[1].isHidden == false {
      lb.text = lb.text! + " fNW"
      adjustLabel()
      //UIApplication.shared.windows[0].makeKeyAndVisible()
    }
  }
  
  
  private func askRestore() {
    let alert = UIAlertController(title: "Alert", message: "Restore last session?\n\nThe last session contains \(restoreIndexLast+1) pages.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
      self.showAlert(message: "Ok logic here")
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.isIdleTimerDisabled = false
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
  
  //url = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
  //let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
  //var characterset = CharacterSet.urlPathAllowed
  //characterset.insert(charactersIn: "-._~")
  //if url.rangeOfCharacter(from: characterset.inverted) != nil {}
  //let characterset = CharacterSet(charactersIn: " ")
  //if url.rangeOfCharacter(from: characterset) != nil {
  //showAlert(message: "has special chars")
  //}
  //let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
  //let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
  //let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
  //if !predicate.evaluate(with: url) {
  //switchToWebsearch()
  //}
  //if !UIApplication.shared.canOpenURL(url) {}
  //let request = URLRequest(url: url)
  //request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
  //request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
  //var oldurl = url.replacingOccurrences(of: " ", with: "+")
  //String(describing: err.code)
  //if let err = error as? URLError {
  //lb.text = lb.text! + "err: \(err._code)"
  //switch err.code {
  //case .cancelled:
  //case .cannotFindHost:
  //case .notConnectedToInternet:
  //case .resourceUnavailable:
  //case .timedOut:
  //}}
  //"err: \((error as NSError).code)"
  //if let err = error as NSError {}
  //private func encodeUrl() {}
  
  
  private func startLoading() {
    var allowed = CharacterSet.alphanumerics
    allowed.insert(charactersIn: "-._~:/?#[]@!$&'()*+,;=%")
    url = url.addingPercentEncoding(withAllowedCharacters: allowed)
    //showAlert(message: url)
    var urlobj = URL(string: url)
    if !(url.hasPrefix("https://") || url.hasPrefix("http://")) {
      urlobj = URL(string: "http://" + url)
    }
    let request = URLRequest(url: urlobj!)
    webview.load(request)
  }
  
  
  func webView(_ webview: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    if let mimeType = navigationResponse.response.mimeType {
      //do some thing with the MIME type
      lb.text = lb.text! + " \(mimeType)"
      adjustLabel()
    } else {
      lb.text = lb.text! + " noMime"
      adjustLabel()
    }
    decisionHandler(.allow)
  }
  
  
  func webView(_ webview: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    let err = error as NSError
    switch err.code {
      case -999: break
      case 101, -1003:
        url = "https://www.google.com/search?q=\(url!)"
        startLoading()
      default:
        showAlert(message: "Error: \(err.code) \(err.localizedDescription)")
    }
    lb.text = lb.text! + " err: \(err.code)"
    adjustLabel()
  }
  
  func webView(_ webview: WKWebView, didFinish navigation: WKNavigation!) {
    urlField.text = webview.url!.absoluteString
    //showAlert(message: defaultUserAgent)
    
    let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=10.0, user-scalable=yes');document.getElementsByTagName('head')[0].appendChild(meta);"
    webview.evaluateJavaScript(javascript, completionHandler: nil)
    
    //for item in webview.backForwardList {}
    //for (item: WKBackForwardListItem) in webview.backForwardList.backList {}
    
    //let historySize = webview.backForwardList.backList.count
    //let firstItem = webview.backForwardList.item(at: -historySize)
    //webview.go(to: firstItem!)
    
    var bflist = "bflist:"
    let historySize = webview.backForwardList.backList.count
    if historySize != 0 {
      for index in -historySize..<0 {
        bflist = bflist + " \(index)/\(historySize)/" + webview.backForwardList.item(at: index)!.url.absoluteString
      }
    }
    
    //var bflist = "bflist:"
    //bfarray.append(webview.url!.absoluteString)
    //bfarray.forEach { item in
      //bflist = bflist + " \(item)"
    //}
    //showAlert(message: bflist)
    
    guard let currentItem = self.webview.backForwardList.currentItem else {
    return
    }
    let urls = (self.webview.backForwardList.backList + [currentItem] + self.webview.backForwardList.forwardList).compactMap { $0.url.absoluteString }
    let currentIndexButLast = self.webview.backForwardList.forwardList.count
    
    UserDefaults.standard.set(urls, forKey: "urls")
    UserDefaults.standard.set(currentIndexButLast, forKey: "currentIndexButLast")
    
    bflist = "bflist:"
    urls.forEach { url in
      bflist = bflist + " " + url
    }
    bflist = bflist + " \(currentIndexButLast)"
    //showAlert(message: "\(bflist)")
    
    //if restoreIndex == 25 {
    //restoreIndexLast = 25
    //}
    
    if restoreIndex == restoreIndexLast {
      restoreIndex += 1
      webview.go(to: webview.backForwardList.item(at: restorePosition * -1)!)
      
      webview2 = WebView(frame: CGRect.zero, history: WebViewHistory())
    //webview2.navigationDelegate = self
    webview2.allowsBackForwardNavigationGestures = true
    view.addSubview(webview2)
    webview2.frame = CGRect(x: 0, y: 84, width: webview.frame.size.width, height: 200)
    webview2.load(URLRequest(url: URL(string: "https://orf.at")!))
    //webview2.loadHTMLString("<strong>So long and thanks for all the fish!</strong><br><a href='https://orf.at'>hoho</a>", baseURL: nil)
    webview3.removeFromSuperview()
    
      //var myBackList = [WKBackForwardListItem]()
      //myBackList.append(webview.backForwardList.item(at: 0)!)
        //override var webview.backForwardList.backList: [WKBackForwardListItem] {
        //return myBackList
        //}
        
    }
    if restoreIndex < restoreIndexLast {
      restoreIndex += 1
      webview.load(URLRequest(url: URL(string: restoreUrls[restoreIndex])!))
      webview3.loadHTMLString("<body style='background-color:transparent;'><h1>Loading last Session... \(restoreIndex+1)/\(restoreIndexLast+1)</h1></body>", baseURL: nil)
    }
    
    //let urlss = UserDefaults.standard.array(forKey: "urls") as? [URL] ?? [URL]()
    //let currentIndexButLasts = UserDefaults.standard.array(forKey: "currentIndexButLast") as? [Int] ?? [Int]()
    
    //struct BackforwardHistory {
      //var urls: [URL] = []
      //var currentIndexButLast: Int32
    //}
    //let backforwardHistory = BackforwardHistory(urls: urls, currentIndexButLast: Int32(currentIndexButLast))
    
    //do {
    //let appSupportDir = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    //let filePath = appSupportDir.appendingPathComponent("bfhist.txt").path
    //NSKeyedArchiver.archiveRootObject(backforwardHistory, toFile: filePath)
    //}
    //catch {}
    
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
        
        lb.text = lb.text! + " cwv"
        adjustLabel()
        
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

