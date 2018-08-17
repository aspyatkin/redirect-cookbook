id = 'redirect'

node['redirect'].to_h.fetch('hosts', []).each do |item|
  redirect_host item['fqdn'] do
    target item['target']
    listen_ipv6 item.fetch('listen_ipv6', true)
    secure item.fetch('secure', true)
    permanent item.fetch('permanent', false)
    pass_request_uri item.fetch('pass_request_uri', false)
    ec_certificates item.fetch('ec_certificates', false)
    action :create
  end
end
