#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fsstp.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fsstp'
  s.version          = '1.0.0'
  s.summary          = 'SSTP client for flutter on ios platform'
  s.description      = <<-DESC
  SSTP/SoftEther client for flutter on ios platform
                       DESC
  s.homepage         = 'https://github.com/devstroop/fsstp'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Akash Shah' => 'akash@devstroop.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{m}'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.libraries = 'resolv'
  
  s.preserve_path = ['ext/ExtParser.framework','openconnect/openconnect.framework']
  s.vendored_frameworks  = ['ext/ExtParser.framework','openconnect/openconnect.framework']


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386','OTHER_LDFLAGS' => ['-framework ExtParser','-framework openconnect']}
end
