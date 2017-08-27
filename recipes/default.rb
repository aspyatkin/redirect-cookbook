id = 'redirect'

node['redirect'].to_h.fetch('hosts', []).each do |item|
  redirect_host item['fqdn'] do
    target item['target']
    secure item.fetch('secure', true)
    permanent item.fetch('permanent', false)
    action :create
  end
end
