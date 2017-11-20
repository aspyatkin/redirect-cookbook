id = 'redirect'

resource_name :redirect_host

property :fqdn, String, name_property: true
property :target, String, required: true
property :secure, [TrueClass, FalseClass], default: true
property :permanent, [TrueClass, FalseClass], default: false
property :pass_request_uri, [TrueClass, FalseClass], default: false

default_action :create

action :create do
  if new_resource.secure
    tls_certificate new_resource.fqdn do
      action :deploy
    end

    tls_item = ::ChefCookbook::TLS.new(node).certificate_entry(new_resource.fqdn)
    is_development = node.chef_environment.start_with?('development')

    nginx_site fqdn do
      cookbook id
      template 'secure.nginx.conf.erb'
      variables(
        fqdn: fqdn,
        target: new_resource.target,
        permanent: new_resource.permanent,
        pass_request_uri: new_resource.pass_request_uri,
        ssl_certificate: tls_item.certificate_path,
        ssl_certificate_key: tls_item.certificate_private_key_path,
        hsts_max_age: node[id]['hsts_max_age'],
        access_log: ::File.join(node['nginx']['log_dir'], "#{fqdn}_access.log"),
        error_log: ::File.join(node['nginx']['log_dir'], "#{fqdn}_error.log"),
        oscp_stapling: !is_development,
        scts: !is_development,
        scts_dir: tls_item.scts_dir,
        hpkp: !is_development,
        hpkp_pins: tls_item.hpkp_pins,
        hpkp_max_age: node[id]['hpkp_max_age']
      )
      action :enable
    end
  else
    nginx_site fqdn do
      cookbook id
      template 'insecure.nginx.conf.erb'
      variables(
        fqdn: fqdn,
        target: new_resource.target,
        permanent: new_resource.permanent,
        pass_request_uri: new_resource.pass_request_uri,
        access_log: ::File.join(node['nginx']['log_dir'], "#{fqdn}_access.log"),
        error_log: ::File.join(node['nginx']['log_dir'], "#{fqdn}_error.log")
      )
      action :enable
    end

  end
end
