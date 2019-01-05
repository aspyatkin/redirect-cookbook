id = 'redirect'

node['redirect'].to_h.fetch('hosts', []).each do |item|
  redirect_host item['fqdn'] do
    target item['target']
    listen_ipv6 item.fetch('listen_ipv6', true)
    default_server item.fetch('default_server', false)
    secure item.fetch('secure', true)
    permanent item.fetch('permanent', false)
    pass_request_uri item.fetch('pass_request_uri', false)
    access_log_options item.fetch('access_log_options', 'combined')
    error_log_options item.fetch('error_log_options', 'error')
    action :create
  end
end
