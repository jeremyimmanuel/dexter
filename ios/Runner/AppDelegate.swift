import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    /// If you have set notifications to be periodically shown, then on older iOS versions (< 10), 
    /// if the application was uninstalled without cancelling all alarms 
    /// then the next time it's installed you may see the "old" notifications being fired. If this is not the desired behaviour, then you can add code similar to the following to the didFinishLaunchingWithOptions method of your AppDelegate class.

    if(!UserDefaults.standard.bool(forKey: "Notification")) {
      UIApplication.shared.cancelAllLocalNotifications()
      UserDefaults.standard.set(true, forKey: "Notification")
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
