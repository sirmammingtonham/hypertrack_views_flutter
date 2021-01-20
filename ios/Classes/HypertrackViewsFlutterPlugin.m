#import "HypertrackViewsFlutterPlugin.h"
#if __has_include(<hypertrack_views_flutter/hypertrack_views_flutter-Swift.h>)
#import <hypertrack_views_flutter/hypertrack_views_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hypertrack_views_flutter-Swift.h"
#endif

@implementation HypertrackViewsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHypertrackViewsFlutterPlugin registerWithRegistrar:registrar];
}
@end
