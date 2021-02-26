// ViewController.swift
// AdsBlockWKWebView
// Created by Wolfgang Weinmann on 2019/12/31.
// Copyright © 2019 Wolfgang Weinmann.

import UIKit
import WebKit

import AVFoundation
import AVKit
import MediaPlayer
import Security

fileprivate let ruleId1 = "MyRuleID 001"
fileprivate let ruleId2 = "MyRuleID 002"


//let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")
//let player = AVPlayer(url: videoURL!)
//let playerViewController = AVPlayerViewController()
//let player = AVPlayer(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!)
let player = AVPlayer(url: URL(string: "http://statslive.infomaniak.ch/playlist/tsfjazz/tsfjazz-high.mp3/playlist.m3u")!)


extension UIColor {
  public convenience init(r: Int, g: Int, b: Int, a: Int) {
    self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
  }
  //static let colorName: UIColor = UIColor.gray.withAlphaComponent(0.75)
  static let viewBgColor: UIColor = UIColor(white: 0.90, alpha: 1)
  static let viewBgLightColor: UIColor = UIColor(white: 0.95, alpha: 1)
  static let appBgColor: UIColor = UIColor(r: 66, g: 46, b: 151, a: 255)
  static let appBgLightColor: UIColor = UIColor(r: 216, g: 213, b: 234, a: 255)
  static let devBgColor: UIColor = .orange
  static let fieldBgColor: UIColor = .white
  static let buttonFgColor: UIColor = .white
}


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


class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
  var webview: WKWebView!
  
  var topNavBgView: UIView!
  //var topNavBgView: UIVisualEffectView!
  var progressView: UIProgressView!
  
  var urlField: UITextField!
  var button: UIButton!
  var lb: UILabel!
  
  var tableView: UITableView!
  var origArray: Array<String> = ["https://www.google.com/"]
  var array: Array<String> = []
  
  var url: String!
  var currentUserAgent: String = "default"
  var defaultUserAgent: String = "default"
  let desktopUserAgent: String = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Safari/605.1.15"
  var navTypeBackForward: Bool = false
  
  var restoreIndex: Int = 0
  var restoreIndexLast: Int = 0
  var restoreUrls: Array<String> = ["https://www.google.com/"]
  var restorePosition: Int = 0
  //var bfarray: Array<String> = []
  var webview2: WebView!
  var webview3: WebView!
  var webviewPrefs: WKPreferences!
  var webviewConfig: WKWebViewConfiguration!
  var avPVC: AVPlayerViewController!
  var navUrl: String!
  var navUrlArray: Array<String> = []
  
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
    
    
    lb.text = lb.text! + " \(UIApplication.shared.windows.count)"
    adjustLabel()
    
    //func findAVPlayerViewController(controller: UIViewController) -> AVPlayerViewController? {
    func findAVPlayerViewController(controller: UIViewController) {
  if controller is AVPlayerViewController {
    lb.text = lb.text! + " a2"
    adjustLabel()
    //return controller as? AVPlayerViewController
  } else {
    //lb.text = lb.text! + " a3"
    //adjustLabel()
    for subcontroller in controller.childViewControllers {
      lb.text = lb.text! + " a4 \(subcontroller)"
      adjustLabel()
      //if subcontroller is AVPlayerViewController {
      //return subcontroller as? AVPlayerViewController
      //}
      
      //if let result = findAVPlayerViewController(controller: subcontroller) {
        //lb.text = lb.text! + " a5"
        //adjustLabel()
        //return result
      //}
    }
  }
  //return nil
}
    
    if UIApplication.shared.windows.count > 99 {
    //if let rootController = UIApplication.shared.keyWindow?.rootViewController {
    if let rootController = UIApplication.shared.windows[4].rootViewController {
    //lb.text = lb.text! + " a1 \((UIApplication.shared.keyWindow?.rootViewController)!)"
    lb.text = lb.text! + " a1 \((UIApplication.shared.windows[4].rootViewController)!)"
    adjustLabel()
    findAVPlayerViewController(controller: rootController)
    //if let avPlayerViewController = findAVPlayerViewController(controller: rootController) {
      //lb.text = lb.text! + " aX \(avPlayerViewController.player!)"
      //adjustLabel()
    //}
  }
  }
  
  //if UIApplication.shared.windows.count > 4 {
  //lb.text = lb.text! + " a1 \((UIApplication.shared.windows[4].rootViewController)!)"
  //adjustLabel()
  //}
  
  if let targetSC = UIApplication.shared.windows[2].rootViewController!.childViewControllers.first(where: { $0 is AVPlayerViewController }) as? AVPlayerViewController {
  avPVC = targetSC
  lb.text = lb.text! + " VC:\(avPVC!)"
  //lb.text = lb.text! + " VCP:\(avPVC!.player)"
  if avPVC.player != nil {
  lb.text = lb.text! + " VCP:\(avPVC!.player!)"
  }
  adjustLabel()
  }
  
  avPVC.player = player
  avPVC.player!.play()
  
  var navlist = "navlist:"
  navUrlArray.forEach { url in
    navlist = navlist + "\n\n" + url
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
    
    //let file = Bundle.main.path(forResource: "Info", ofType: "plist")!
    //let p = URL(fileURLWithPath: file)
    //let text = try? String(contentsOf: p)
    
    var text = "error"
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
      do {
        //text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        //text = try String(contentsOfFile: path)
        text = try String(contentsOf: URL(fileURLWithPath: path))
      } catch {}
    }
    //if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {}
    
    /*VerursachtError
    //let blitem = webview2.backForwardList.item(at: 0)!.url.absoluteString
    let blitem = webview2.backForwardList.forwardList.count
    let blcount1 = webview2.backForwardList.backList.count
    webview2.backForwardList.backList.removeAll()
    let blcount2 = webview2.backForwardList.backList.count
    showAlert(message: "\(navlist) \(blitem) \(blcount1)/\(blcount2) \(appVersion!) \(text!)")
    */
    
    showAlert(message: "\(navlist)\n\nfilecontent: \(text)\n\nappversion: \(appVersion!)")
    
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
    cell?.contentView.backgroundColor = .appBgLightColor
    //cell?.backgroundColor = .gray
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //urlField.endEditing(true)
    if array[indexPath.row] != "&showall" {
      urlField.endEditing(true)
      url = array[indexPath.row]
      startLoading()
    }
    urlField.text = "\(array[indexPath.row])"
    origArray = origArray.filter{$0 != urlField.text!}
    origArray.insert(urlField.text!, at: 0)
    UserDefaults.standard.set(origArray, forKey: "origArray")
    if array[indexPath.row] == "&showall" {
      array = origArray
      tableView.reloadData()
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    //url = urlField.text!
    //startLoading()
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      self.deleteButtonClicked(url: self.array[indexPath.row])
    }
    let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
      self.editButtonClicked(url: self.array[indexPath.row])
    }
    edit.backgroundColor = .appBgColor
    let dev = UITableViewRowAction(style: .normal, title: "Dev") { (action, indexPath) in
      self.devButtonClicked(url: self.array[indexPath.row])
    }
    dev.backgroundColor = .devBgColor
    return [delete, edit, dev]
  }
  
  @available(iOS 11.0, *)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, bool) in
      self.deleteButtonClicked(url: self.array[indexPath.row])
    }
    let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, bool) in
      self.editButtonClicked(url: self.array[indexPath.row])
    }
    edit.backgroundColor = .appBgColor
    let dev = UIContextualAction(style: .normal, title: "Dev") { (action, view, bool) in
      self.devButtonClicked(url: self.array[indexPath.row])
    }
    dev.backgroundColor = .devBgColor
    let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit, dev])
    swipeActions.performsFirstActionWithFullSwipe = false
    return swipeActions
  }
  
  @objc func deleteButtonClicked(url: String) {
    origArray = origArray.filter{$0 != url}
    UserDefaults.standard.set(origArray, forKey: "origArray")
    array = array.filter{$0 != url}
    tableView.reloadData()
  }
  
  @objc func editButtonClicked(url: String) {
    urlField.endEditing(true)
    
    var goBackBy = 2
    if goBackBy > webview.backForwardList.backList.count {
      goBackBy = webview.backForwardList.backList.count
    }
    webview.go(to: webview.backForwardList.item(at: goBackBy * -1)!)
    
    showAlert(message: "E:\(url)")
    //lb.text! += " E"
    //adjustLabel()
  }
  
  @objc func devButtonClicked(url: String) {
    urlField.endEditing(true)
    
    if lb.isHidden == true {
      lb.isHidden = false
      webview.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
      webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    } else {
      lb.isHidden = true
      webview.removeObserver(self, forKeyPath: "URL")
      webview.removeObserver(self, forKeyPath: "estimatedProgress")
      UIPasteboard.general.string = lb.text!
    }
    
    webview.evaluateJavaScript("var el = document.querySelector('input[type=password]'); if (el !== null) { window.webkit.messageHandlers.iosListener.postMessage('iP' + el.getAttribute('name')); }", completionHandler: nil)
    //let urlArr = webview.url!.absoluteString.components(separatedBy: "/")
    //let server = urlArr[2]
    let server = "www.example.com"
    let account = "tester2"
    let password = ("test123").data(using: String.Encoding.utf8)!
    var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword, kSecAttrAccount as String: account, kSecAttrServer as String: server, kSecValueData as String: password]
    var status: OSStatus = SecItemDelete(query as CFDictionary)
    var message = "1-del: \(status)\n\n"
    status = SecItemAdd(query as CFDictionary, nil)
    message += "2-add: \(status)\n\n"
    query = [kSecClass as String: kSecClassInternetPassword, kSecAttrAccount as String: account, kSecAttrServer as String: server, kSecReturnData as String: kCFBooleanTrue!]
    var dataTypeRef: AnyObject? = nil
    status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    if status == noErr {
      let result = String(data: (dataTypeRef as! Data?)!, encoding: .utf8)
      message += "3-load: \(result!)"
    } else {
      message += "3-load: \(status)"
    }
    showAlert(message: message)
    
    //SecAddSharedWebCredential(server as CFString, account as CFString, "test12" as CFString) { (error) in
      //self.showAlert(message: "fail2 \(error)")
    //}
    
    //showAlert(message: "D:\(url)")
    //lb.text! += " D"
    lb.text! += " \(defaultUserAgent) \(server)"
    adjustLabel()
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    switch textField {
      case urlField:
        if tableView.isDescendant(of: view) {
          tableView.removeFromSuperview()
        }
        if webview3.isDescendant(of: view) {
          webview3.removeFromSuperview()
        }
        navUrlArray = []
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
    
    let attributedString = NSMutableAttributedString(string: lb.text!)
    if let regularExpression = try? NSRegularExpression(pattern: "STOP") {
      let matchedResults = regularExpression.matches(in: lb.text!, options: [], range: NSRange(location: 0, length: attributedString.length))
      for matched in matchedResults {
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: matched.range)
      }
      lb.attributedText = attributedString
    }
    
    lb.frame.size.height = lb.sizeThatFits(CGSize(width: lb.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
    lb.frame.origin.y = view.frame.height - lb.frame.size.height - insetB + 14
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
          //shouldHideHomeIndicator = true
        } else {
          shouldHideHomeIndicator = true
        }
        if #available(iOS 11, *) {
          setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
      }
      
      urlField.frame.origin.x = insetL
      urlField.frame.origin.y = insetT
      urlField.frame.size.width = view.frame.width - insetL - insetR
      urlField.frame.size.height = 30
      if insetT == 0 {
        urlField.frame.origin.y += 5
      }
      if insetL == 0 {
        urlField.frame.origin.x += 5
        urlField.frame.size.width -= 5
      }
      if insetR == 0 {
        urlField.frame.size.width -= 5
      }
      if button.isDescendant(of: view) {
        urlField.frame.size.width -= 85
      }
      
      button.frame.origin.x = urlField.frame.origin.x + urlField.frame.size.width + 5
      button.frame.origin.y = urlField.frame.origin.y
      button.frame.size.width = 80
      button.frame.size.height = urlField.frame.size.height
      
      topNavBgView.frame.origin.x = 0
      topNavBgView.frame.origin.y = 0
      topNavBgView.frame.size.width = view.frame.width
      topNavBgView.frame.size.height = urlField.frame.origin.y + urlField.frame.size.height + 5
      
      //progressView.frame.origin.x = insetL
      progressView.frame.origin.x = urlField.frame.origin.x
      progressView.frame.origin.y = urlField.frame.origin.y + urlField.frame.size.height + 2
      //progressView.frame.size.width = view.frame.width - insetL - insetR
      progressView.frame.size.width = urlField.frame.size.width
      progressView.frame.size.height = 2
      progressView.transform = progressView.transform.scaledBy(x: 1, y: 1.5)
      
      tableView.frame.origin.x = insetL
      tableView.frame.origin.y = urlField.frame.origin.y + urlField.frame.size.height + 5
      tableView.frame.size.width = view.frame.width - insetL - insetR
      tableView.frame.size.height = 185
      tableView.reloadData()
      
      webview.frame.origin.x = insetL
      webview.frame.origin.y = urlField.frame.origin.y + urlField.frame.size.height + 5
      webview.frame.size.width = view.frame.width - insetL - insetR
      //webview.frame.size.height = view.frame.height - urlField.frame.origin.y - urlField.frame.size.height - 5 - insetB
      webview.frame.size.height = view.frame.height - urlField.frame.origin.y - urlField.frame.size.height - 5
      
      //webview.frame.origin.y = 0
      //webview.frame.size.height = view.frame.height
      
      if webview2.isDescendant(of: view) {
        webview.frame.origin.y += 200
        webview.frame.size.height -= 200
      }
      
      //webview.scrollView.contentSize = CGSize(width: self.view.frame.width - insetL - insetR, height: self.view.frame.height - insetT - urlField.frame.size.height - 10)
      //webview.scrollView.contentInset = UIEdgeInsets(top: insetT + urlField.frame.size.height + 10, left: 0, bottom: 0, right: 0)
      //webview.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: insetT + urlField.frame.size.height + 10, left: 0, bottom: 0, right: 0)
      //webview.scrollView.contentSize.height = self.view.frame.height - insetT - urlField.frame.size.height - 10
      //webview.scrollView.frame.origin.y = insetT + urlField.frame.size.height + 100
      //webview.scrollView.frame.size.height = self.view.frame.height - insetT - urlField.frame.size.height - 100
      //webview.scrollView.contentOffset.y = -insetT - urlField.frame.size.height - 10
      
      /*
      webview.setValue(true, forKey: "_haveSetObscuredInsets")
      webview.setValue(UIEdgeInsets(top: insetT + urlField.frame.size.height + 10, left: 0, bottom: insetB, right: 0), forKey: "_obscuredInsets")
      webview.scrollView.contentInset = UIEdgeInsets(top: insetT + urlField.frame.size.height + 10, left: 0, bottom: insetB, right: 0)
      if #available(iOS 11, *) {
        webview.scrollView.contentInsetAdjustmentBehavior = .never
      }
      //webview.scrollView.scrollIndicatorInsets = webview.scrollView.contentInset
      webview.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: urlField.frame.size.height + 10, left: 0, bottom: 0, right: 0)
      */
      
      webview3.frame.origin.x = insetL
      //webview3.frame.origin.y = urlField.frame.origin.y
      webview3.frame.origin.y = urlField.frame.origin.y + urlField.frame.size.height + 5
      webview3.frame.size.width = view.frame.width - insetL - insetR
      //webview3.frame.size.height = view.frame.height - urlField.frame.origin.y
      webview3.frame.size.height = view.frame.height - urlField.frame.origin.y - urlField.frame.size.height - 5
      
      lb.frame.origin.x = insetL + 21
      lb.frame.size.width = view.frame.width - insetL - insetR - 42
      adjustLabel()
      
      lastDeviceOrientation = deviceOrientation
      lb.text! += " \(insetT) \(insetB) \(insetL) \(insetR) \(deviceOrientation)"
      adjustLabel()
    }
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if (UserDefaults.standard.object(forKey: "origArray") != nil) {
          origArray = UserDefaults.standard.stringArray(forKey: "origArray") ?? [String]()
        }
        
        //view.backgroundColor = .lightGray
        //view.backgroundColor = UIColor(white: 0.90, alpha: 1)
        view.backgroundColor = .viewBgColor
        
        UserDefaults.standard.register(defaults: [
            ruleId1 : false,
            ruleId2 : false
            ])
        UserDefaults.standard.synchronize()
        
        webviewPrefs = WKPreferences()
        webviewPrefs.javaScriptEnabled = true
        webviewPrefs.javaScriptCanOpenWindowsAutomatically = false
        
        webviewConfig = WKWebViewConfiguration()
        webviewConfig.preferences = webviewPrefs
        webviewConfig.allowsInlineMediaPlayback = true
        webviewConfig.mediaTypesRequiringUserActionForPlayback = []
        //webviewConfig.mediaTypesRequiringUserActionForPlayback = .all
        //webviewConfig.ignoresViewportScaleLimits = true
        webviewConfig.userContentController.addUserScript(WKUserScript(source: "var el = document.querySelector('meta[name=viewport]'); if (el !== null) { el.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=0.1, maximum-scale=15.0, user-scalable=yes'); } window.webkit.messageHandlers.iosListener.postMessage('dF'); setTimeout(function() { var videos = document.getElementsByTagName('video'); for (var i = 0; i < videos.length; i++) { videos.item(i).pause(); window.webkit.messageHandlers.iosListener.postMessage('vs' + videos.item(i).src + 'vc' + videos.item(i).currentSrc); } }, 3000); var el = document.querySelector('input[type=file]'); if (el !== null) { window.webkit.messageHandlers.iosListener.postMessage('iF'); el.removeAttribute('capture'); }", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        webviewConfig.userContentController.addUserScript(WKUserScript(source: "document.addEventListener('click', function() { window.webkit.messageHandlers.iosListener.postMessage('c'); })", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        webviewConfig.userContentController.add(self, name: "iosListener")
        
        webview = WKWebView(frame: view.bounds, configuration: webviewConfig)
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        webview.allowsLinkPreview = false
        webview.clipsToBounds = false
        webview.scrollView.clipsToBounds = false
        
webview.evaluateJavaScript("navigator.userAgent") { (result, error) in
          self.defaultUserAgent = result as! String
        }
        //webview.isHidden = true
        view.addSubview(webview)
        
        counter += 1
        
        lb = UILabel(frame: CGRect.zero)
        lb.text = "log:"
        lb.textAlignment = .center
        lb.font = lb.font.withSize(12)
        lb.backgroundColor = .devBgColor
        lb.numberOfLines = 0
        //lb.isUserInteractionEnabled = true
        lb.isHidden = true
        view.addSubview(lb)
        
        topNavBgView = UIView(frame: CGRect.zero)
        //topNavBgView.backgroundColor = UIColor.viewBgColor.withAlphaComponent(0.85)
        topNavBgView.backgroundColor = .viewBgColor
        //topNavBgView = UIVisualEffectView(frame: CGRect.zero)
        //topNavBgView.effect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        //topNavBgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(topNavBgView)
        
        progressView = UIProgressView(frame: CGRect.zero)
        //progressView.progressViewStyle = .bar
        progressView.progressTintColor = .appBgColor
        progressView.trackTintColor = .clear
        view.addSubview(progressView)
        
        urlField = UITextField(frame: CGRect.zero)
        urlField.placeholder = "Type your Address"
        urlField.font = UIFont.systemFont(ofSize: 15)
        urlField.tintColor = .appBgColor
        urlField.backgroundColor = .fieldBgColor
        //urlField.borderStyle = UITextField.BorderStyle.roundedRect
        //urlField.layer.borderWidth = 0
        
        urlField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        urlField.leftViewMode = .always
        
        urlField.layer.cornerRadius = 5
        urlField.clipsToBounds = true
        urlField.autocapitalizationType = .none
        urlField.autocorrectionType = UITextAutocorrectionType.no
        
        let keyboardView = UIView(frame: CGRect(x: 0, y: view.frame.height - 2, width: view.frame.width, height: 2))
        keyboardView.backgroundColor = .appBgColor
        urlField.inputAccessoryView = keyboardView
        
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
        //button.frame = CGRect(x: 100, y: 400, width: 100, height: 50)
        button.backgroundColor = .appBgColor
        
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.buttonFgColor, for: .normal)
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
        tableView.backgroundColor = .viewBgLightColor
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
        tableView.separatorColor = .appBgColor
        //tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        
        if (UserDefaults.standard.object(forKey: "urls") != nil) {
        restoreUrls = UserDefaults.standard.stringArray(forKey: "urls") ?? [String]()
        }
        
        if restoreUrls[restoreIndex] != "https://www.google.com/" {
          restoreUrls.insert("https://www.google.com/", at: 0)
        }
        
        UserDefaults.standard.set(restoreUrls, forKey: "urlsBackup")
        
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
    for (index, url) in restoreUrls.enumerated() {
      //self.webview.load(URLRequest(url: url))
      //DispatchQueue.main.async {
      //self.webview.load(URLRequest(url: URL(string: url)!))
      //}
      bflist += "<br><br>\(index+1): \(url)"
    }
    bflist += "<br><br>RestorePosition: \(restorePosition)"
    //DispatchQueue.main.async {
      //self.showAlert(message: "\(bflist)")
    //}
    
    webview2 = WebView(frame: CGRect.zero, history: WebViewHistory())
    //webview2.navigationDelegate = self
    webview2.allowsBackForwardNavigationGestures = true
    //view.addSubview(webview2)
    webview2.frame = CGRect(x: 0, y: 84, width: webview.frame.size.width, height: 200)
    webview2.load(URLRequest(url: URL(string: "https://orf.at")!))
    //webview2.loadHTMLString("<strong>So long and thanks for all the fish!</strong><br><a href='https://orf.at'>hoho</a>", baseURL: nil)
    
    webview3 = WebView(frame: CGRect.zero, history: WebViewHistory())
    //webview3.loadHTMLString("<body style='background-color:transparent;'><h1>Loading last Session... \(restoreIndex+1)/\(restoreIndexLast+1)</h1><br><br>\(bflist)</body>", baseURL: nil)
    webview3.loadHTMLString("<body style='background-color:transparent;color:white;'><h1 id='a' style='position:fixed;top:50px;background-color:white;color:black;'>Loading last Session... \(restoreIndex+1)/\(restoreIndexLast+1)</h1><br><br><div id='b' onclick='copy()'>\(bflist)</div><script>function copy() { var range = document.createRange(); range.selectNode(document.getElementById('b')); window.getSelection().removeAllRanges(); window.getSelection().addRange(range); document.execCommand('copy'); window.getSelection().removeAllRanges(); }</script></body>", baseURL: nil)
    webview3.isOpaque = false
    //webview3.backgroundColor = .orange
    //webview3.scrollView.backgroundColor = .orange
    webview3.backgroundColor = .appBgColor
    webview3.scrollView.backgroundColor = .appBgColor
    webview3.scrollView.isScrollEnabled = true
    //webview3.scrollView.bounces = false
    view.addSubview(webview3)
    
    avPVC = AVPlayerViewController()
    NotificationCenter.default.addObserver(self, selector: #selector(focusNewWindow), name: .UIWindowDidResignKey, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.togglePlayPauseCommand.addTarget { [unowned self] event in
      if self.avPVC.player!.rate == 0.0 {
        self.avPVC.player!.play()
      } else {
        self.avPVC.player!.pause()
      }
      return .success
    }
    
    
        //url = URL(string: "https://www.google.com/")
        url = "https://www.google.com/"
        
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
  
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    lb.text = lb.text! + " m:\(message.body)"
    adjustLabel()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let key = change?[NSKeyValueChangeKey.newKey] {
      
      if keyPath == "URL" {
        webview.evaluateJavaScript("var el = document.querySelector('input[type=file]'); if (el !== null) { window.webkit.messageHandlers.iosListener.postMessage('iF' + el.getAttribute('accept')); el.removeAttribute('accept'); el.removeAttribute('capture'); el.removeAttribute('onclick'); el.click(); }", completionHandler: nil)
        lb.text! += " oV:" + String(String(describing: key).prefix(15))
        adjustLabel()
      }
      
      if keyPath == "estimatedProgress" {
        progressView.progress = Float(webview.estimatedProgress)
        if webview.estimatedProgress == 1 {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressView.progress = Float(0)
          }
        }
        lb.text! += " oV:" + String(String(describing: key).prefix(5))
        adjustLabel()
      }
      
    }
  }
  
  @objc private func focusNewWindow() {
    if UIApplication.shared.windows.count > 1 && UIApplication.shared.windows[1].isHidden == false {
      ////
      //UIApplication.shared.windows[2].isHidden = true
      ////
      //lb.text = lb.text! + " fNW\(UIApplication.shared.windows.count) \(UIApplication.shared.windows[0].isHidden) \(UIApplication.shared.windows[1].isHidden) \(UIApplication.shared.windows[2].isHidden) \(UIApplication.shared.windows[3].isHidden)"
      lb.text = lb.text! + " fNW\(UIApplication.shared.windows.count)\(UIApplication.shared.windows[2].isHidden) \(navUrl!)"
      adjustLabel()
      //showAlert(message: "navUrl: \(navUrl!)")
      //navUrlArray.removeAll()
      //UIApplication.shared.windows[0].makeKeyAndVisible()
    }
  }
  
  @objc private func enterBackground() {
    avPVC.player = nil
    lb.text = lb.text! + " eBg"
    adjustLabel()
  }
  
  @objc private func enterForeground() {
    UIApplication.shared.isIdleTimerDisabled = true
    avPVC.player = player
    lb.text = lb.text! + " eFg"
    adjustLabel()
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
    if currentUserAgent == "default" {
      webview.customUserAgent = desktopUserAgent
      currentUserAgent = "desktop"
    } else {
      webview.customUserAgent = nil
      currentUserAgent = "default"
    }
    webview.reload()
    
    /*
    if webview.customUserAgent != desktopUserAgent {
    //if defaultUserAgent == "default" {
      webview.evaluateJavaScript("navigator.userAgent") { (result, error) in
        self.defaultUserAgent = result as! String
        self.webview.customUserAgent = self.desktopUserAgent
        //self.webview.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36"
        self.webview.reload()
      }
    } else {
      webview.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.2 Mobile/15E148 Safari/604.1"
      //webview.customUserAgent = nil
      //webview.customUserAgent = defaultUserAgent
      //defaultUserAgent = "default"
      webview.reload()
    }
    */
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
    
    /*if !(url.hasPrefix("https://") || url.hasPrefix("http://")) {
      urlobj = URL(string: "http://" + url)
    }*/
    if let regularExpression = try? NSRegularExpression(pattern: "^.{1,10}://") {
      let matchedNumber = regularExpression.numberOfMatches(in: url, options: [], range: NSRange(location: 0, length: url.count))
      if matchedNumber == 0 {
        urlobj = URL(string: "http://" + url)
      }
      lb.text! += " \(matchedNumber)"
      lb.text! += "|\(urlobj!.absoluteString)"
      adjustLabel()
    }
    navTypeBackForward = false
    
    let request = URLRequest(url: urlobj!)
    webview.load(request)
  }
  
  
  func webView(_ webview: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let urlStr = navigationAction.request.url?.absoluteString {
      //Full path self.webview.url
      navUrl = urlStr
      navUrlArray.insert(navUrl, at: 0)
      if navUrl == "about:blank" {
        navUrlArray.insert("AB:" + self.webview.url!.absoluteString, at: 0)
      }
    }
    
    if currentUserAgent == "default" {
      webview.customUserAgent = nil
    } else {
      webview.customUserAgent = desktopUserAgent
    }
    
    
    lb.text! += " NT(\(navigationAction.navigationType.rawValue))"
    adjustLabel()
    if navigationAction.navigationType != .other {
      navTypeBackForward = false
    }
    if navigationAction.navigationType == .backForward {
      ////
      //navTypeBackForward = true
      ////
    }
    if navigationAction.navigationType == .other && navTypeBackForward == true {
      lb.text! += " STOP"
      adjustLabel()
      //sleep(2)
      decisionHandler(.cancel)
      return
    }
    
    
    if navigationAction.navigationType == .linkActivated {
      let unilinkUrls: Array<String> = ["https://open.spotify.com", "https://www.amazon.de", "https://mobile.willhaben.at", "https://www.willhaben.at", "https://maps.google.com", "https://tvthek.orf.at"]
      var unilinkStop = false
      unilinkUrls.forEach { item in
        if navigationAction.request.url!.absoluteString.lowercased().hasPrefix(item.lowercased()) {
          if !webview.url!.absoluteString.lowercased().hasPrefix(item.lowercased()) {
            unilinkStop = true
          }
        }
      }
      if unilinkStop == true {
        webview.load(navigationAction.request)
        lb.text! += " uni:\(navigationAction.request.url!.absoluteString)"
        adjustLabel()
        decisionHandler(.cancel)
        return
      }
    }
    
    let desktopUrls: Array<String> = ["https://apps.apple.com", "https://identitysafe.norton.com", "https://de.yahoo.com"]
    var desktopStop = false
    desktopUrls.forEach { item in
      if navigationAction.request.url!.absoluteString.lowercased().hasPrefix(item.lowercased()) {
        desktopStop = true
      }
    }
    if desktopStop == true {
      webview.customUserAgent = desktopUserAgent
      lb.text! += " desk:\(navigationAction.request.url!.absoluteString)"
      adjustLabel()
      decisionHandler(.allow)
      return
    }
    
    //if navigationAction.request.url?.scheme == "https" && UIApplication.shared.canOpenURL(navigationAction.request.url!) {
      //decisionHandler(.cancel)
      //return
    //}
    //&& navigationAction.targetFrame == nil {
    
    if navigationAction.request.url?.scheme == "itms-appss" {
      webview.stopLoading()
      webview.customUserAgent = desktopUserAgent
      let newUrlStr = navigationAction.request.url!.absoluteString.replacingOccurrences(of: "itms-appss", with: "https")
      let newUrl = URL(string: newUrlStr)
      //var newUrl = URLRequest(url: URL(string: newUrlStr)!)
      //newUrl.setValue(desktopUserAgent, forHTTPHeaderField: "User-Agent")
      if counter < 3 {
      counter += 1
      webview.load(URLRequest(url: newUrl!))
      //webview.load(newUrl)
      lb.text! += " itms-appss:\(navigationAction.request.url!.absoluteString)"
      adjustLabel()
      }
      //webview.customUserAgent = nil
      //UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
      decisionHandler(.cancel)
      return
    }
    
    if navigationAction.request.url?.scheme == "tel" {
      UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
      decisionHandler(.cancel)
      return
    }
    decisionHandler(.allow)
  }
  
  func webView(_ webview: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    
    if let urlStr = navigationResponse.response.url?.absoluteString {
      navUrl = urlStr
      navUrlArray.insert("RE:" + navUrl, at: 0)
    }
    
    if let mimeType = navigationResponse.response.mimeType {
      //do some thing with the MIME type
      
      if mimeType == "application/application/pdf" {
        if let data = try? Data(contentsOf: navigationResponse.response.url!) {
          webview.stopLoading()
          webview.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: navigationResponse.response.url!)
          decisionHandler(.cancel)
          return
        }
      }
      
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
    
    lb.text = lb.text! + " w:dF"
    adjustLabel()
    //webview.evaluateJavaScript("var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=0, maximum-scale=10.0, user-scalable=yes'); document.getElementsByTagName('head')[0].appendChild(meta);", completionHandler: nil)
    //webview.evaluateJavaScript("var el = document.querySelector('meta[name=viewport]'); if (el !== null) { el.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=0.1, maximum-scale=15.0, user-scalable=yes'); }", completionHandler: nil)
    
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
      
      //let restoreUrlsList = "LASTbflist: " + restoreUrls.joined(separator:" ")
      //webview3.loadHTMLString("<body style='background-color:transparent;'><h1>Loading last Session... \(restoreIndex+1)/\(restoreIndexLast+1)</h1><br><br>\(restoreUrlsList)</body>", baseURL: nil)
      
webview3.evaluateJavaScript("document.getElementById('a').innerHTML = 'Loading last Session... \(restoreIndex+1)/\(restoreIndexLast+1)';", completionHandler: nil)
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
  
  private func endLoading() {
    lb.text = lb.text! + " end"
    adjustLabel()
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
                    
    let ruleId2File = Bundle.main.url(forResource: "adaway", withExtension: "json")!
    let resourceValues = try! ruleId2File.resourceValues(forKeys: [.contentModificationDateKey])
    let ruleId2FileDate = resourceValues.contentModificationDate!
    var ruleId2FileDateLast = Calendar.current.date(byAdding: .year, value: -1, to: ruleId2FileDate)
    if (UserDefaults.standard.object(forKey: "ruleId2FileDateLast") != nil) {
      ruleId2FileDateLast = UserDefaults.standard.object(forKey: "ruleId2FileDateLast") as? Date
    }
    self?.lb.text = (self?.lb.text)! + " \(ruleId2FileDate) \(ruleId2FileDateLast!)"
    self?.adjustLabel()
    if ruleId2FileDate > ruleId2FileDateLast! {
      //if #available(iOS 11.0, *) {
      //webview.configuration.userContentController.removeAllContentRuleLists()
      WKContentRuleListStore.default().removeContentRuleList(forIdentifier: ruleId2, completionHandler: { _ in })
      UserDefaults.standard.set(false, forKey: ruleId2)
      //let group = DispatchGroup()
      //group.enter()
      //setupContentBlockFromStringLiteral {
        //group.leave()
      //}
      //group.enter()
      //setupContentBlockFromFile {
        //group.leave()
      //}
      UserDefaults.standard.set(ruleId2FileDate, forKey: "ruleId2FileDateLast")
      self?.lb.text = (self?.lb.text)! + " UPD"
      self?.adjustLabel()
      self?.setupContentBlockFromFile(completion)
      return
      //}
    }
                    
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
    
    //Just for invalidating target="_blank"
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        lb.text = lb.text! + " cwv"
        adjustLabel()
        
        guard let url = navigationAction.request.url else {
            return nil
        }
        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame else {
            
            navUrlArray.insert("NW:" + url.absoluteString, at: 0)
            
            webView.load(URLRequest(url: url))
            return nil
        }
        return nil
    }
    

}

