import Foundation
import Flutter
import UIKit
import HyperTrackViews

// NOTE!!: Literally none of this is tested yet because i'm not gonna buy a mac
public class SwiftHypertrackViewsFlutterPlugin: NSObject, FlutterPlugin {
  let mHyperTrackView: HyperTrackViews
  var cancelSubscription: Cancel = {}
  let encoder = JSONEncoder()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hypertrack_views_flutter/methods", binaryMessenger: registrar.messenger())
    let instance = SwiftHypertrackViewsFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)

      case "initialize":
        guard let key = call.arguments as? String else {
            result(
              FlutterError( code: "squabbit", 
                message: "Invalid arguments",
                details: "Expected 1 String arg." ))
            return
       }
        mHyperTrackView = HyperTrackViews(publishableKey: key) // i dont know swift at all and i cant double check so...

      case "getDeviceMovementStatus":
        guard let deviceId = call.arguments as? String else {
              result(
                FlutterError( code: "squabbit", 
                  message: "Invalid arguments",
                  details: "Expected 1 String arg." ))
              return
        }
        cancelSubscription = hyperTrackViews.movementStatus(for: deviceId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(movementStatus):
              let data = try! encoder.encode(myStruct)
              result(String(data: data, encoding: .utf8)!) // swift syntax whack
            case let .failure(error):
              result(
              FlutterError( code: "bruhmoment", 
                message: "Failed to get MovementStatus",
                details: "Good luck debugging" ))
            }
        }

      case "subscribeToDeviceUpdates": //TODO
        guard let deviceId = call.arguments as? String else {
              result(
                FlutterError( code: "squabbit", 
                  message: "Invalid arguments",
                  details: "Expected 1 String arg." ))
              return
        }
        cancelSubscription = hyperTrackViews.movementStatus(for: deviceId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(movementStatus):
              // probably have to manually send data to the callbacks here since the android sdk is different for some reason
              // and i need them to function the same way...........

              // let data = try! encoder.encode(myStruct)
              // result(String(data: data, encoding: .utf8)!) // swift syntax whack
            case let .failure(error):
              result(
              FlutterError( code: "bruhmoment", 
                message: "Failed to get MovementStatus",
                details: "Good luck debugging" ))
            }
        }
      case "stopAllUpdates":
        cancelSubscription()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
