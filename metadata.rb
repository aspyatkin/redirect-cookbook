name 'redirect'
maintainer 'Alexander Pyatkin'
maintainer_email 'aspyatkin@gmail.com'
license 'MIT'
description 'Create Nginx host to redirect to another website'
long_description ::IO.read(::File.join(::File.dirname(__FILE__), 'README.md'))
version '1.6.0'

scm_url = 'https://github.com/aspyatkin/redirect-cookbook'
source_url scm_url if respond_to?(:source_url)
issues_url "#{scm_url}/issues" if respond_to?(:issues_url)

depends 'nginx'
depends 'tls', '~> 3.1.0'
