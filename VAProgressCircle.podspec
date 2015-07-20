Pod::Spec.new do |s|
  s.name             = "VAProgressCircle"
  s.version          = "0.0.3"
  s.summary          = "A custom loading bar for iOS"
  s.homepage         = "https://github.com/MitchellMalleo/VAProgressCircle"
  s.license          = 'MIT'
  s.author           = { "Mitch Malleo" => "mitchellmalleo@gmail.com" }
  s.source           = { :git => "https://github.com/MitchellMalleo/VAProgressCircle.git", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.requires_arc = true
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
end

