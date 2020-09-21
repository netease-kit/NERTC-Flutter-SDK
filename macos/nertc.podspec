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
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
