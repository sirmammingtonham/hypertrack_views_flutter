import Foundation
import Flutter
import UIKit
import HyperTrackViews

// NOTE!!: Literally none of this is tested yet because i'm not gonna buy a mac
public class SwiftHypertrackViewsFlutterPlugin: NSObject, FlutterPlugin {
    var mHyperTrackView: HyperTrackViews!
    var cancelSubscription: Cancel = {}
    let encoder = JSONEncoder()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "hypertrack_views_flutter/methods", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterStreamsChannel(name: "hypertrack_views_flutter/events", binaryMessenger: registrar.messenger())
        let instance = SwiftHypertrackViewsFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
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
            mHyperTrackView = HyperTrackViews(publishableKey: key)
            result(true)
            
        case "getDeviceMovementStatus":
            guard let deviceId = call.arguments as? String else {
                result(
                    FlutterError( code: "squabbit",
                                  message: "Invalid arguments",
                                  details: "Expected 1 String arg." ))
                return
            }
            
            cancelSubscription = mHyperTrackView.movementStatus(for: deviceId) { [weak self] res in
                guard let self = self else { return }
                
                switch res {
                case let .success(movementStatus):
                    if let data = try? JSONSerialization.data(withJSONObject: movementStatus.toJSON(), options: []) {
                        let serializedString = String(data: data, encoding: .utf8)
                        result(serializedString)
                    }
                case let .failure(error):
                    result(
                        FlutterError( code: "bruhmoment",
                                      message: "Failed to get MovementStatus, ensure deviceId exists!",
                                      details: String(describing: error) ))
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
            cancelSubscription = mHyperTrackView.movementStatus(for: deviceId) { [weak self] res in
                guard let self = self else { return }
                
                switch res {
                case let .success(movementStatus): break
                    // probably have to manually send data to the callbacks here since the android sdk is different for some reason
                    // and i need them to function the same way...........
                    
                    result(movementStatus.toJSON())
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

class StreamListener: NSObject, FlutterStreamHandler {
    let mHyperTrackView: HyperTrackViews
    var cancelSubscription: Cancel = {}
    init(view: HyperTrackViews) {
        self.mHyperTrackView = view
    }
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard let deviceId = arguments as? String else {
            return FlutterError( code: "squabbit",
                                 message: "Invalid arguments",
                                 details: "Expected 1 String arg." )
        }
        
        cancelSubscription = mHyperTrackView.subscribeToMovementStatusUpdates(for: deviceId) {
            [weak self] res in
            guard let self = self else { return }
            
            switch res {
            case let .success(movementStatus): break
                events(movementStatus.toJSON())
            case let .failure(error):
                events(FlutterError( code: "bruhmoment",
                                     message: "Failed to get MovementStatus, ensure deviceId exists!",
                                     details: String(describing: error) ))
            }
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelSubscription()
        return nil
    }
}
