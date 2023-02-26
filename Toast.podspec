Pod::Spec.new do |s|
  s.name             = 'Toast'
  s.version          = '1.0.0'
  s.summary          = 'A short description of Toast.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/cocomanbar/Toast'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cocomanbar' => '125322078@qq.com' }
  s.source           = { :git => 'https://github.com/cocomanbar/Toast.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'

  s.source_files = 'Toast/Classes/**/*'
  
  s.resource_bundles = {
    'Toast' => ['Toast/Assets/*.xcassets']
  }
    
end
