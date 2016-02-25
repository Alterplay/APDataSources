Pod::Spec.new do |s|
  s.name             = "APDataSources"
  s.version          = "0.1.2"
  s.summary          = "One more implementation of UITableView and UICollectionView data sources."
  s.homepage         = "https://github.com/Alterplay/APDataSources"
  s.license          = 'MIT'
  s.author           = { "Nickolay Sheika" => "nickolai.sheika@alterplay.com", 
						"Evgeniy Gurtovoy" => "evgeniy.gurtovoy@alterplay.com", 
						"Serg Krivoblotsky" => "krivoblotsky@me.com" }
  s.source           = { :git => "https://github.com/Alterplay/APDataSources.git", :tag => s.version.to_s }
  
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
 
end
