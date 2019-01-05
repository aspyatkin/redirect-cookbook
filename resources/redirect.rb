id = 'redirect'

resource_name :redirect_host

property :fqdn, String, name_property: true
property :target, String, required: true
property :listen_ipv6, [TrueClass, FalseClass], default: true
property :default_server, [TrueClass, FalseClass], default: false
property :secure, [TrueClass, FalseClass], default: true
property :permanent, [TrueClass, FalseClass], default: false
property :pass_request_uri, [TrueClass, FalseClass], default: false
property :access_log_options, String, default: 'combined'
property :error_log_options, String, default: 'error'

default_action :create

action :create do
  ngx_vhost_variables = {
    fqdn: new_resource.fqdn,
    target: new_resource.target,
    listen_ipv6: new_resource.listen_ipv6,
    default_server: new_resource.default_server,
    permanent: new_resource.permanent,
    pass_request_uri: new_resource.pass_request_uri,
    access_log: ::File.join(node['nginx']['log_dir'], "#{new_resource.fqdn}_access.log"),
    access_log_options: new_resource.access_log_options,
    error_log: ::File.join(node['nginx']['log_dir'], "#{new_resource.fqdn}_error.log"),
    error_log_options: new_resource.error_log_options,
    secure: new_resource.secure
  }

  if new_resource.secure
    tls_rsa_certificate new_resource.fqdn do
      action :deploy
    end

    tls_helper = ::ChefCookbook::TLS.new(node)
    tls_rsa_item = tls_helper.rsa_certificate_entry(new_resource.fqdn)
    tls_ec_item = nil
    is_development = node.chef_environment.start_with?('development')
    ec_certificates = tls_helper.has_ec_certificate?(new_resource.fqdn)

    ngx_vhost_variables.merge!({
      ec_certificates: ec_certificates,
      ssl_rsa_certificate: tls_rsa_item.certificate_path,
      ssl_rsa_certificate_key: tls_rsa_item.certificate_private_key_path,
      hsts_max_age: node[id]['hsts_max_age'],
      oscp_stapling: !is_development,
      scts_rsa_dir: tls_rsa_item.scts_dir
    })

    if ec_certificates
      tls_ec_certificate new_resource.fqdn do
        action :deploy
      end

      tls_ec_item = tls_helper.ec_certificate_entry(new_resource.fqdn)
      ngx_vhost_variables.merge!({
        ssl_ec_certificate: tls_ec_item.certificate_path,
        ssl_ec_certificate_key: tls_ec_item.certificate_private_key_path,
        scts_ec_dir: tls_ec_item.scts_dir
      })
    end

    has_scts = tls_rsa_item.has_scts? && (tls_ec_item.nil? ? true : tls_ec_item.has_scts?)
    ngx_vhost_variables.merge!({
      scts: has_scts
    })
  end

  nginx_site new_resource.fqdn do
    cookbook id
    template 'nginx.conf.erb'
    variables ngx_vhost_variables
    action :enable
  end
end
