# redirect-cookbook
[![Chef cookbook](https://img.shields.io/cookbook/v/redirect.svg?style=flat-square)]()
[![license](https://img.shields.io/github/license/aspyatkin/redirect-cookbook.svg?style=flat-square)]()

Create Nginx host to redirect to another website. Makes use of [ngx](https://supermarket.chef.io/cookbooks/ngx) cookbook under the hood.

## Usage

### Resource

```ruby
redirect_host 'www.domain.tld' do
  target 'domain.tld'  # host to redirect to (REQUIRED)
  path '/hello'  # path to redirect to (default: '')
  listen_ipv6 true  # listen on IPv6 address (default: true)
  default_server true  # include 'default_server' option in Nginx listen directive (default: false)
  secure true  # redirect to HTTPS (default: true)
  oscp_stapling true  # when secure is enabled, enable OSCP stapling (default: true)
  resolvers %w(8.8.8.8 1.1.1.1)  # when secure and oscp_stapling are enabled, set up resolvers (default: Google and CloudFlare DNS servers)
  resolver_valid 300  # cache name resolution results for the specified number of seconds (default: 600)
  resolver_timeout 5  # set timeout for the name resolution (default: 10)
  resolver_ipv6 true  # look up both IPv4 and IPv6 addresses while resolving (default: false)
  permanent false  # either 301 or 302 HTTP code (default: false)
  pass_request_uri true  # redirect with path and arguments (default: false)
  access_log_options 'off'  # Nginx access_log options string (default: 'combined', use 'off' to disable access_log)
  error_log_options 'crit'  # Nginx error_log level (default: 'error')
end
```

## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
