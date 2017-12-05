version = '7.0.7-13'
checksum = '0f55553b9cce280e9a4e9952034833f4'
url = "https://github.com/ImageMagick/ImageMagick/archive/#{version}.tar.gz"
filepath = "/tmp/#{version}.tar.gz"
flags = ['--with-pango']

package 'tar'

remote_file url do
  source   url
  checksum checksum
  path     filepath
  backup   false
end

bash 'unarchive_source' do
  cwd  ::File.dirname(filepath)

  code <<-EOH
    tar zxf #{::File.basename(filepath)} -C #{::File.dirname(filepath)}
  EOH

  not_if { ::File.directory?("/tmp/#{version}") }
end

bash 'compile_source' do
  cwd  ::File.dirname(filepath)

  code <<-EOH
    cd /tmp/#{version} && ./configure #{flags.join(' ')} && make && make install
  EOH
end
