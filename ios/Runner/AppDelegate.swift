import UIKit
import Flutter
import Firebase

@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // FirebaseApp.configure() https://stackoverflow.com/questions/65154152/unable-to-run-flutter-app-on-ios-default-app-has-been-already-configured
    // https://github.com/FirebaseExtended/flutterfire/issues/6433
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
