Pod::Spec.new do |s|
  s.name         = 'NWImageViewer'
  s.version      = '1.0'
  s.summary      = 'UIView which allows to zoom in and out of a UIImage'
  s.author = {
    'Tom Nys' => 'tom.nys@netwalk.be'
  }
  s.source = {
    :git => 'https://github.com/tnys/NWImageViewer.git',
    :tag => '1.0.0'
  }
  s.source_files = 'NWImageViewer/NWTapDetectingView.{h,m}', 'NWImageViewer/NWTapDetectingImageView.{h,m}', 'NWImageViewer/NWZoomingImageView.{h,m}'
  s.requires_arc = true
end