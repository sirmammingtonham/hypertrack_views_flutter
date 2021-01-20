import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('hypertrack_views_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await HypertrackViewsFlutter.platformVersion, '42');
  });
}
