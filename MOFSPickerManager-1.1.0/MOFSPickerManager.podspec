Pod::Spec.new do |s|
  s.name = "MOFSPickerManager"
  s.version = "1.1.0"
  s.summary = "PickerManager for iOS"
  s.license = "MIT"
  s.authors = {"memoriesofsnows"=>"luoyuant@163.com"}
  s.homepage = "https://github.com/memoriesofsnows/MOFSPickerManagerDemo.git"
  s.description = "iOS PickerView\u6574\u5408\uFF0C\u4E00\u884C\u4EE3\u7801\u8C03\u7528\uFF08\u7701\u5E02\u533A\u4E09\u7EA7\u8054\u52A8+\u65E5\u671F\u9009\u62E9+\u666E\u901A\u9009\u62E9\uFF09"
  s.social_media_url = "http://www.jianshu.com/u/f4284f2cc646"
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/MOFSPickerManager.framework'
end
