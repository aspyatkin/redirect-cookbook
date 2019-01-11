id = 'redirect'

node['redirect'].to_h.fetch('hosts', []).each do |item|
  redirect_host item['fqdn'] do
    target item['target']
    path item.fetch('path', '')
    listen_ipv6 item.fetch('listen_ipv6', true)
    default_server item.fetch('default_server', false)
    secure item.fetch('secure', true)
    oscp_stapling item.fetch('oscp_stapling', true)
    resolvers item.fetch('resolvers', %w(8.8.8.8 1.1.1.1 8.8.4.4 1.0.0.1))
    resolver_valid item.fetch('resolver_valid', 600)
    resolver_timeout item.fetch('resolver_timeout', 10)
    permanent item.fetch('permanent', false)
    pass_request_uri item.fetch('pass_request_uri', false)
    access_log_options item.fetch('access_log_options', 'combined')
    error_log_options item.fetch('error_log_options', 'error')
    action :create
  end
end
