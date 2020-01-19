Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "Beaver"
s.summary = "File and Codable objects persistence micro-library for iOS"
s.requires_arc = true
s.framework = 'XCTest'
s.version = "1.2.1"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Ravi Tripathi" => "ravitripathi1996@gmail.com" }

s.homepage = "https://github.com/ravitripathi/Beaver"

s.source = { :git => "https://github.com/ravitripathi/Beaver.git",
             :tag => "#{s.version}" }

s.source_files = "Beaver/**/*.{swift}"

s.swift_version = "5.0"

end

