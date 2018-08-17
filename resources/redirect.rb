id = 'redirect'

resource_name :redirect_host

property :fqdn, String, name_property: true
property :target, String, required: true
property :listen_ipv6, [TrueClass, FalseClass], default: true
property :secure, [TrueClass, FalseClass], default: true
property :permanent, [TrueClass, FalseClass], default: false
property :pass_request_uri, [TrueClass, FalseClass], default: false
property :ec_certificates, [TrueClass, FalseClass], default: false

default_action :create

action :create do
  ngx_vhost_variables = {
    fqdn: fqdn,
    target: new_resource.target,
    listen_ipv6: new_resource.listen_ipv6,
    permanent: new_resource.permanent,
    pass_request_uri: new_resource.pass_request_uri,
    access_log: ::File.join(node['nginx']['log_dir'], "#{fqdn}_access.log"),
    error_log: ::File.join(node['nginx']['log_dir'], "#{fqdn}_error.log"),
    secure: new_resource.secure,
    ec_certificates: new_resource.ec_certificates
  }

  if new_resource.secure
    tls_rsa_certificate new_resource.fqdn do
      action :deploy
    end

    tls_rsa_item = ::ChefCookbook::TLS.new(node).rsa_certificate_entry(new_resource.fqdn)
    tls_ec_item = nil
    is_development = node.chef_environment.start_with?('development')

    ngx_vhost_variables.merge!({
      ssl_rsa_certificate: tls_rsa_item.certificate_path,
      ssl_rsa_certificate_key: tls_rsa_item.certificate_private_key_path,
      hsts_max_age: node[id]['hsts_max_age'],
      oscp_stapling: !is_development,
      scts_rsa_dir: tls_rsa_item.scts_dir,
      hpkp: !is_development,
      hpkp_pins: tls_rsa_item.hpkp_pins,
      hpkp_max_age: node[id]['hpkp_max_age']
    })

    if new_resource.ec_certificates
      tls_ec_certificate new_resource.fqdn do
        action :deploy
      end

      tls_ec_item = ::ChefCookbook::TLS.new(node).ec_certificate_entry(new_resource.fqdn)
      ngx_vhost_variables.merge!({
        ssl_ec_certificate: tls_ec_item.certificate_path,
        ssl_ec_certificate_key: tls_ec_item.certificate_private_key_path,
        scts_ec_dir: tls_ec_item.scts_dir,
        hpkp_pins: (ngx_vhost_variables[:hpkp_pins] + tls_ec_item.hpkp_pins).uniq,
      })
    end

    has_scts = tls_rsa_item.has_scts? && (tls_ec_item.nil? ? true : tls_ec_item.has_scts?)
    ngx_vhost_variables.merge!({
      scts: has_scts
    })
  end

  nginx_site fqdn do
    cookbook id
    template 'nginx.conf.erb'
    variables ngx_vhost_variables
    action :enable
  end
end
