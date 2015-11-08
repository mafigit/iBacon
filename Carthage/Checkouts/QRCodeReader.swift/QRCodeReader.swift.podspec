Pod::Spec.new do |s|
  s.name             = 'QRCodeReader.swift'
  s.module_name      = 'QRCodeReader'
  s.version          = '5.2.1'
  s.license          = 'MIT'
  s.summary          = 'Simple QRCode and 1D bar code reader in Swift'
  s.homepage         = 'https://github.com/yannickl/QRCodeReader.swift.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/QRCodeReader.swift.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/qrcodereader.swift-screenshot.jpg'

  s.ios.deployment_target = '8.0'

  s.framework    = 'AVFoundation'
  s.source_files = 'QRCodeReader/*.swift'
  s.requires_arc = true
end
