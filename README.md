# redirect-cookbook
[![Chef cookbook](https://img.shields.io/cookbook/v/redirect.svg?style=flat-square)]()
[![license](https://img.shields.io/github/license/aspyatkin/redirect-cookbook.svg?style=flat-square)]()

Create Nginx host to redirect to another website

## Usage

### Resource

```ruby
redirect_host 'www.domain.tld' do
  target 'domain.tld'
  listen_ipv6 true  # listen on IPv6 address (default: true)
  secure true  # redirect to HTTPS (default: true)
  permanent false  # either 301 or 302 HTTP code (default: false)
  pass_request_uri true  # redirect with path and arguments (default: false)
  ec_certificates true  # use EC certificates along with RSA ones (default: false)
end
```

### Recipe
Add `recipe[redirect::default]` to your run list and specify redirect hosts in node attributes:

```json
{
  "redirect": {
    "hosts": [
      {
        "fqdn": "www.domain.tld",
        "target": "domain.tld",
        "listen_ipv6": true,
        "secure": true,
        "permanent": false,
        "pass_request_uri": true,
        "ec_certificates": true
      }
    ]
  }
}
```

## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
