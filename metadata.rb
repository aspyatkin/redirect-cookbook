name 'redirect'
maintainer 'Aleksandr Piatkin'
maintainer_email 'oss@aptkn.ch'
license 'MIT'
description 'Create Nginx host to redirect to another website'
long_description ::IO.read(::File.join(::File.dirname(__FILE__), 'README.md'))
version '4.1.0'

scm_url = 'https://github.com/aspyatkin/redirect-cookbook'
source_url scm_url if respond_to?(:source_url)
issues_url "#{scm_url}/issues" if respond_to?(:issues_url)

depends 'ngx', '~> 2.2'
depends 'tls', '~> 4.1'
