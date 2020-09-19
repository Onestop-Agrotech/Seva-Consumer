import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    UIApplication.shared.isStatusBarHidden = false
    let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    let k = NSDictionary(contentsOfFile:filePath!)
    let GmapsAPIKey = k?.object(forKey: "GoogleMapsAPIKey") as! String
    
    GMSServices.provideAPIKey(GmapsAPIKey)
    FirebaseApp.configure()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
