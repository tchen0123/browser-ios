import Foundation



func hashString (obj: AnyObject) -> String {
  return String(ObjectIdentifier(obj).uintValue)
}


public class LegacyUserContentController
{
  var scriptHandlers = [String:WKScriptMessageHandler]()

  var scripts:[WKUserScript] = []
  weak var webView: LegacyWebView?

  func addScriptMessageHandler(scriptMessageHandler: WKScriptMessageHandler, name: String) {

    scriptHandlers[name] = scriptMessageHandler

    // do injection of script to frames

//    let message:LegacyScriptMessage = LegacyScriptMessage()
//    message.writeableMessageBody = "{1:2}"
//    message.writeableName = name
//
//    for (_, handler) in self.scriptHandlers {
//      handler.userContentController(WKUserContentController(), didReceiveScriptMessage: message)
//    }
  }

  func addUserScript(script:WKUserScript) {
    scripts.append(script)
  }

  public init(_ webView: LegacyWebView) {
    self.webView = webView
  }

  public func inject() {
    let js = LegacyJSContext()

    guard let web = webView else { return }

    for (name, handler) in scriptHandlers {
      js.installHandlerForWebView(web, handlerName: name, handler:handler)
    }

    for script in scripts {
      webView?.stringByEvaluatingJavaScriptFromString(script.source)
    }
  }
}

public class LegacyWebViewConfiguration
{
  let userContentController: LegacyUserContentController
  public init(webview: LegacyWebView) {
    userContentController = LegacyUserContentController(webview)
  }
}

//
//class LegacyWebViewNavigationDelegate {
//   public func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
//
//}