id = 'redirect'

resource_name :redirect_host

property :fqdn, String, name_property: true
property :target, String, required: true
property :path, String, default: ''
property :listen_ipv6, [TrueClass, FalseClass], default: true
property :default_server, [TrueClass, FalseClass], default: false
property :secure, [TrueClass, FalseClass], default: true
property :hsts_max_age, Integer, default: 15_768_000
property :oscp_stapling, [TrueClass, FalseClass], default: true
property :resolvers, Array, default: %w(8.8.8.8 1.1.1.1 8.8.4.4 1.0.0.1)
property :resolver_valid, Integer, default: 600
property :resolver_timeout, Integer, default: 10
property :permanent, [TrueClass, FalseClass], default: false
property :pass_request_uri, [TrueClass, FalseClass], default: false
property :access_log_options, String, default: 'combined'
property :error_log_options, String, default: 'error'

default_action :create

action :create do
  ngx_vhost_variables = {
    fqdn: new_resource.fqdn,
    target: new_resource.target,
    path: new_resource.path,
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
    ec_certificates = tls_helper.has_ec_certificate?(new_resource.fqdn)

    ngx_vhost_variables.merge!({
      ec_certificates: ec_certificates,
      ssl_rsa_certificate: tls_rsa_item.certificate_path,
      ssl_rsa_certificate_key: tls_rsa_item.certificate_private_key_path,
      hsts_max_age: new_resource.hsts_max_age,
      oscp_stapling: new_resource.oscp_stapling,
      resolvers: new_resource.resolvers,
      resolver_valid: new_resource.resolver_valid,
      resolver_timeout: new_resource.resolver_timeout
    })

    if ec_certificates
      tls_ec_certificate new_resource.fqdn do
        action :deploy
      end

      tls_ec_item = tls_helper.ec_certificate_entry(new_resource.fqdn)
      ngx_vhost_variables.merge!({
        ssl_ec_certificate: tls_ec_item.certificate_path,
        ssl_ec_certificate_key: tls_ec_item.certificate_private_key_path
      })
    end
  end

  nginx_site new_resource.fqdn do
    cookbook id
    template 'nginx.conf.erb'
    variables ngx_vhost_variables
    action :enable
  end
end
