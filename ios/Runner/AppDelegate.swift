import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller = window?.rootViewController as! FlutterViewController
    let webviewFactory = OpenTokFactory(controller: controller)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    registrar(forPlugin: "plugins/open_tok")?.register(webviewFactory, withId: "plugins/open_tok")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
