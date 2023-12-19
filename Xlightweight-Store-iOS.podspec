#
# Be sure to run `pod lib lint Xlightweight-Store-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Xlightweight-Store-iOS'
  s.version          = '0.0.1'
  s.summary          = 'A Lightweight storage on iOS, such as SharedPreferences on Android'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A light weight key-value store (SharedPreferences & NSUserdefaults) with saving to separated/customizable xml/plist.
                       DESC

  s.homepage         = 'https://github.com/isaacselement/Xlightweight-Store-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SnowGirls' => 'june@Tesla.com' }
  s.source           = { :git => 'https://github.com/isaacselement/Xlightweight-Store-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Xlightweight-Store-iOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Xlightweight-Store-iOS' => ['Xlightweight-Store-iOS/Assets/*.png']
  # }

  s.public_header_files = 'Xlightweight-Store-iOS/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
