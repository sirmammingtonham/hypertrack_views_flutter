#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint hypertrack_views_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'hypertrack_views_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.2'
  s.dependency 'HyperTrackViews'
  s.dependency 'streams_channel'

  # s.pods_project.targets.each do |t|
  #   t.build_configurations.each do |config|
  #     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.2'
  #   end
  # end
end
