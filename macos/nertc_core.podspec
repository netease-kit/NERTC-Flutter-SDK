#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nertc_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nertc_core'
  s.version          = '5.9.11'
  s.summary          = 'Flutter plugin for NetEase RTC SDK.'
  s.description      = <<-DESC
Flutter plugin for NetEase RTC SDK.
                       DESC
  s.homepage         = 'https://yunxin.163.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NetEase, Inc.' => 'liuqijun@corp.netease.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
#   s.public_header_files = [
#     'Classes/**/*.h',
#     '$(PODS_ROOT)/../wrapper/**/*.h'
#   ]

  s.dependency 'FlutterMacOS'
#   s.dependency 'Flutter'
  s.dependency 'NERtcSDK-MacOS', '5.9.11'


  s.platform = :osx, '11.5'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.swift_version = '5.0'
end
