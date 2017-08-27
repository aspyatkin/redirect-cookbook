# redirect-cookbook
Create Nginx host to redirect to another website

## Usage

### Resource

```ruby
redirect_host 'www.domain.tld' do
  target 'domain.tld'
  secure true  # Redirect to HTTPS
  permanent false  # Either 301 or 302 HTTP code
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
        "secure": true,
        "permanent": false
      }
    ]
  }
}
```

## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
