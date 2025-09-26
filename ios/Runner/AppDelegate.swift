import UIKit
import Flutter
import Firebase
import GoogleMaps
// import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate,MessagingDelegate {
    // MARK: - Declaration
    
    let platform_channel: String = "flutter.native/helper"

    // MARK: - Lifecycle method
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
//         Settings.initialize()
//        Settings.shared.isAdvertiserTrackingEnabled = true
//         Settings.shared.isAdvertiserIDCollectionEnabled = true
        
        configurePushNotification(application)
        configureApiEncryption()
        GMSServices.provideAPIKey("AIzaSyD6tjP2svi4on_yP9x4f9mUKbnlLFY1Y4Q")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Custom method
    func configureApiEncryption() {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let platformChannel = FlutterMethodChannel(name: platform_channel, binaryMessenger: controller.binaryMessenger)

        platformChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            if (call.method == "encryptRequest") {
                self?.encrypteRequest(result: result,request: call.arguments as! [String : Any])
            } else if (call.method == "occusearch_encryptRequest") {
                self?.encrypteNewRequest(result: result,request: call.arguments)
            } else if (call.method == "encrypt_userEmail") {
                self?.getJWTToken(result: result, email: call.arguments as! String)
            } else if (call.method == "occusearch_encrypt_userEmail") {
                self?.getNewJWTToken(result: result, data: call.arguments as! [String : Any])
            } else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }
    
    func configurePushNotification(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        } else {
          let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
    }
    
    // MARK: - Messaging Delegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        //guard let token = fcmToken else { return }
    }
    
    // MARK: - JWT encryption method
    private func encrypteRequest(result: FlutterResult,request:[String:Any]) {
        let str = RCryptoHelper.encryptedParams(request)
        result(str)
    }
    
    private func encrypteNewRequest(result: FlutterResult,request:Any?) {
        let str = RCryptoHelper.encryptedNewParams(request)
        result(str)
    }
    
    private func getJWTToken(result: FlutterResult,email:String) {
        let str = RCryptoHelper.generateJWT(emailID: email)
        result(str)
    }
    
    private func getNewJWTToken(result: FlutterResult, data: [String:Any]) {
        let str = RCryptoHelper.generateNewJWT(emailId: (data["email"] as? String) ?? "", deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "", issuer: Bundle.main.bundleIdentifier ?? "", audience: (data["domain"] as? String) ?? "", timeComponent: .day, timeValue: 1)
        result(str)
    }
}
