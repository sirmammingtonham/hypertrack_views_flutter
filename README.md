# hypertrack_views_flutter

trying to create an interface for the hypertrack views sdk in flutter

installs the hypertrack views sdk for [Android](https://github.com/hypertrack/views-android) and [iOS](https://github.com/hypertrack/views-ios), and uses flutter platform channels to communicate between them and the dart api.

first time using kotlin and swift :)

# Usage

Initialize the plugin with `HypertrackViewsFlutter views = HypertrackViewsFlutter(PUBLISHABLE_KEY);`

Get a single device update with `MovementStatus test = await views.getDeviceUpdate(DEVICE_ID);`

Subscribe to device updates with 
```dart
views.subscribeToDeviceUpdates(DEVICE_ID).listen((MovementStatus event) {
  do stuff;
});
```
