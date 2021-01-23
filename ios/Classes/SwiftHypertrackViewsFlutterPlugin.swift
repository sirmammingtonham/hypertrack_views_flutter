import Flutter
import Foundation
import HyperTrackViews
import UIKit

public class SwiftHypertrackViewsFlutterPlugin: NSObject, FlutterPlugin {
    private var mHyperTrackView: HyperTrackViews?
    private var cancelSubscription: Cancel = {}
    private static var eventChannel: FlutterStreamsChannel!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "hypertrack_views_flutter/methods", binaryMessenger: registrar.messenger())
        eventChannel = FlutterStreamsChannel(name: "hypertrack_views_flutter/events", binaryMessenger: registrar.messenger())
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
                    FlutterError(code: "squabbit",
                                 message: "Invalid arguments",
                                 details: "Expected 1 String arg."))
                return
            }
            mHyperTrackView = HyperTrackViews(publishableKey: key)
            SwiftHypertrackViewsFlutterPlugin.eventChannel.setStreamHandlerFactory { (_) -> (FlutterStreamHandler & NSObjectProtocol)? in
                return StreamListener(parent: self)
            }
            result(true)

        case "getDeviceMovementStatus":
            guard let deviceId = call.arguments as? String else {
                result(
                    FlutterError(code: "squabbit",
                                 message: "Invalid arguments",
                                 details: "Expected 1 String arg."))
                return
            }
            guard let view = mHyperTrackView else {
                result(
                    FlutterError(code: "monke",
                                 message: "SDK not initialized!",
                                 details: "run initialize()"))
                return
            }

            cancelSubscription = view.movementStatus(for: deviceId) { [weak self] res in
                guard let self = self else { return }

                switch res {
                case let .success(movementStatus):
                    result(movementStatus.toMap())
                case let .failure(error):
                    result(
                        FlutterError(code: "bruhmoment",
                                     message: "Failed to get MovementStatus, ensure deviceId exists!",
                                     details: String(describing: error)))
                }
            }
        case "stopAllUpdates":
            cancelSubscription()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    class StreamListener: NSObject, FlutterStreamHandler {
        unowned let parent: SwiftHypertrackViewsFlutterPlugin
        var cancelSubscription: Cancel = {}

        init(parent: SwiftHypertrackViewsFlutterPlugin) {
            self.parent = parent
        }

        func onListen(withArguments arguments: Any?, eventSink emitter: @escaping FlutterEventSink) -> FlutterError? {
            guard let deviceId = arguments as? String else {
                return FlutterError(code: "squabbit",
                                    message: "Invalid arguments",
                                    details: "Expected 1 String arg.")
            }
            guard let view = parent.mHyperTrackView else {
                return
                    FlutterError(code: "monke",
                                 message: "SDK not initialized!",
                                 details: "run initialize()")
            }

            cancelSubscription = view.subscribeToMovementStatusUpdates(for: deviceId) {
                [weak self] res in
                guard let self = self else { return }

                switch res {
                case let .success(movementStatus):
                    emitter(movementStatus.toMap())
                case let .failure(error):
                    emitter(FlutterError(code: "bruhmoment",
                                         message: "Failed to get MovementStatus, ensure deviceId exists!",
                                         details: String(describing: error)))
                }
            }
            return nil
        }

        func onCancel(withArguments _: Any?) -> FlutterError? {
            cancelSubscription()
            return nil
        }
    }
}
