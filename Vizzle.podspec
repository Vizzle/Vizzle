
Pod::Spec.new do |s|

  s.name         = "Vizzle"
  s.version      = "0.0.2"
  s.summary      = "An iOS MVC framework"
  s.description  = <<-DESC
                   Vizzle is an iOS MVC frameowrk
                   DESC

  s.homepage     = "https://github.com/Vizzle/Vizzle"
  s.license      = "MIT"
  s.author       = { "xta0" => "jayson.xu@foxmail.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/Vizzle/Vizzle.git", :tag => "#{s.version}" }
  s.source_files  = "Vizzle/**/*.{h,m,c,mm}"
  s.frameworks ='Foundation', 'CoreGraphics', 'UIKit'
  s.requires_arc = true
  s.dependency "AFNetworking","3.0.0"

  
end
