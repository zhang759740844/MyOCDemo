Pod::Spec.new do |s|
  s.name = 'StaticWithCocoapods'
  s.version = '0.2.0'
  s.summary = 'A short description of StaticWithCocoapods.'
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"Zachary"=>"759740844@qq.com"}
  s.homepage = 'https://github.com/zhang759740844'
  s.description = 'TODO: Add long description of the pod here.'
  s.frameworks = ["UIKit", "MapKit"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.preserve_paths       = 'ios/StaticWithCocoapods.framework'
  s.ios.public_header_files  = 'ios/StaticWithCocoapods.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/StaticWithCocoapods.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/StaticWithCocoapods.framework'
end
