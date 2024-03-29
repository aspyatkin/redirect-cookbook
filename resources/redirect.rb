provides :redirect_host
resource_name :redirect_host

property :fqdn, String, name_property: true
property :target, String, required: true
property :path, String, default: ''
property :listen_ipv6, [TrueClass, FalseClass], default: true
property :default_server, [TrueClass, FalseClass], default: false
property :secure, [TrueClass, FalseClass], default: true
property :hsts_max_age, Integer, default: 15_768_000
property :ocsp_stapling, [TrueClass, FalseClass], default: true
property :resolvers, Array, default: %w[8.8.8.8 1.1.1.1 8.8.4.4 1.0.0.1]
property :resolver_valid, Integer, default: 600
property :resolver_timeout, Integer, default: 10
property :resolver_ipv6, [TrueClass, FalseClass], default: false
property :permanent, [TrueClass, FalseClass], default: false
property :pass_request_uri, [TrueClass, FalseClass], default: false
property :access_log_options, String, default: 'combined'
property :error_log_options, String, default: 'error'

property :vlt_provider, Proc, default: lambda { nil }
property :vlt_format, Integer, default: 1

default_action :create

action :create do
  vhost_vars = {
    fqdn: new_resource.fqdn,
    target: new_resource.target,
    path: new_resource.path,
    listen_ipv6: new_resource.listen_ipv6,
    default_server: new_resource.default_server,
    permanent: new_resource.permanent,
    pass_request_uri: new_resource.pass_request_uri,
    access_log_options: new_resource.access_log_options,
    error_log_options: new_resource.error_log_options,
    secure: new_resource.secure,
    certificate_entries: []
  }

  if new_resource.secure
    vhost_vars.merge!(
      hsts_max_age: new_resource.hsts_max_age,
      ocsp_stapling: new_resource.ocsp_stapling,
      resolvers: new_resource.resolvers,
      resolver_valid: new_resource.resolver_valid,
      resolver_timeout: new_resource.resolver_timeout,
      resolver_ipv6: new_resource.resolver_ipv6
    )

    tls_rsa_certificate new_resource.fqdn do
      vlt_provider new_resource.vlt_provider
      vlt_format new_resource.vlt_format
      action :deploy
    end

    tls = ::ChefCookbook::TLS.new(node, vlt_provider: new_resource.vlt_provider, vlt_format: new_resource.vlt_format)
    vhost_vars[:certificate_entries] << tls.rsa_certificate_entry(new_resource.fqdn)

    if tls.has_ec_certificate?(new_resource.fqdn)
      tls_ec_certificate new_resource.fqdn do
        vlt_provider new_resource.vlt_provider
        vlt_format new_resource.vlt_format
        action :deploy
      end

      vhost_vars[:certificate_entries] << tls.ec_certificate_entry(new_resource.fqdn)
    end
  end

  nginx_vhost new_resource.fqdn do
    cookbook 'redirect'
    template 'nginx.conf.erb'
    variables(lazy {
      vhost_vars.merge(
        access_log: ::File.join(node.run_state['nginx']['log_dir'], "#{new_resource.fqdn}_access.log"),
        error_log: ::File.join(node.run_state['nginx']['log_dir'], "#{new_resource.fqdn}_error.log")
      )
    })
    action :enable
  end
end
