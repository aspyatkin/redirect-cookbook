# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [3.1.0] - 2020-11-11
### Added
- Introduced a new `redirect_host` resource property: `vlt_format`.

### Changed
- Update [tls](https://supermarket.chef.io/cookbooks/tls) dependency to version 4.1.

## [3.0.0] - 2020-09-28
### Added
- Introduced a new `redirect_host` resource property: `vlt_provider`.

### Changed
- Update [tls](https://supermarket.chef.io/cookbooks/tls) dependency to version 4.

## [2.1.1] - 2019-07-23
### Added
- Introduced a new `redirect_host` resource property: `resolver_ipv6`.

## [2.1.0] - 2019-04-14
### Changed
- Make use of an updated version of [tls](https://supermarket.chef.io/cookbooks/tls) cookbook.

## [2.0.0] - 2019-04-10
### Changed
- Make use of [ngx](https://supermarket.chef.io/cookbooks/ngx) cookbook under the hood.

### Removed
- Deleted the default recipe.

## [1.6.0] - 2019-01-10
### Added
- Introduced a new `redirect_host` resource property: `path`.
- Introduced a new `redirect_host` resource property: `hsts_max_age`.
- Introduced a new `redirect_host` resource property: `oscp_stapling`.
- Introduced a new `redirect_host` resource property: `resolvers`.
- Introduced a new `redirect_host` resource property: `resolver_valid`.
- Introduced a new `redirect_host` resource property: `resolver_timeout`.

### Removed
- Deleted `node['redirect']['hsts_max_age']`.
- Static CT entries will no longer be configured.

## [1.5.1] - 2019-01-05
### Fixed
- Fixed the default recipe.

## [1.5.0] - 2019-01-04
### Removed
- HPKP Header will no longer be set.
- Deleted the `redirect_host` resource property: `ec_certificates`.

## [1.4.3] - 2018-12-17
### Added
- Introduced a new `redirect_host` resource property: `default_server`.

## [1.4.2] - 2018-12-13
### Added
- Introduced a new `redirect_host` resource property: `access_log_options`.
- Introduced a new `redirect_host` resource property: `error_log_options`.

## [1.4.1] - 2018-10-14
### Fixed
- Chef 14 compatibility.

## [1.4.0] - 2018-08-17
### Added
- Create a CHANGELOG.
