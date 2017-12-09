options = if node['imagemagick']['options']
  node['imagemagick']['options']
else
  []
end

ark 'imagemagick' do
  url node['imagemagick']['source_url']
  version node['imagemagick']['version']
  checksum node['imagemagick']['checksum']
  make_opts options
  action [ :configure, :build_with_make ]
end
