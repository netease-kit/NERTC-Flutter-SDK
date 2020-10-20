#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nertc.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nertc'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for NetEase RTC SDK.'
  s.description      = <<-DESC
Flutter plugin for NetEase RTC SDK.
                       DESC
  s.homepage         = 'https://yunxin.163.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NetEase, Inc.' => 'liuqijun@corp.netease.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'NIMLibYuv', '1.0.1'
  s.dependency 'NERtcSDK', '3.7.0'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
