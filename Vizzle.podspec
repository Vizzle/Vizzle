
Pod::Spec.new do |s|

  s.name         = "Vizzle.podspec"
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
  s.public_header_files = "Vizzle/Vizzle.h"
  s.requires_arc = true

  
end
