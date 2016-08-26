Pod::Spec.new do |s|
s.name             = 'JLFrameView'
s.version          = '0.1.0'
s.summary          = 'IOS 7 JLFrameView.'
s.description      = <<-DESC
Play image sequence use CoreAnimation.
DESC
s.homepage         = 'https://github.com/JulianSong/JLFrameView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'junliang.song' => 'junliang.song@dianping.com' }
s.source           = { :git => 'https://github.com/JulianSong/JLFrameView.git', :tag => s.version.to_s }
s.ios.deployment_target = '8.0'
s.source_files = 'JLFrameView/Classes/*'
s.public_header_files = 'JLFrameView/Classes/*.h'
s.frameworks = 'UIKit'
end