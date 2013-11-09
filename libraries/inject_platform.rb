require_relative 'provider_service_slackware'
require_relative 'provider_package_slackpkg'
require_relative 'resource_slackpkg'

Chef::Platform::platforms.merge!(
  :slackware   => {
    :default => {
      :package => Chef::Provider::Package::Slackpkg,
      :service => Chef::Provider::Service::Slackware,
    }
  }
)
