#import "LocationPermissionsPlugin.h"
#if __has_include(<location_permissions/location_permissions-Swift.h>)
#import <location_permissions/location_permissions-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "location_permissions-Swift.h"
#endif

@implementation LocationPermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLocationPermissionsPlugin registerWithRegistrar:registrar];
}
@end
