Pod::Spec.new do |s|
  s.name             = 'ZGHttp'
  s.version          = '0.1.3'
  s.summary          = '壮观基础网络库ZGHttp'
  s.description      = <<-DESC
  
                       ## 壮观基础网络库
                       1. 封装AFNetworking的网络请求
                       2. 后台上传请求封装
                       DESC

  s.homepage         = 'https://github.com/liresidue/ZGHttp'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hitter' => '601453611@qq.com' }
  s.source           = { :git => 'https://github.com/liresidue/ZGHttp.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'ZGHttp/Classes/**/*'
  s.dependency 'AFNetworking'
end
