require 'chef/resource/package'

class Chef
  class Resource
    class SlackpkgPackage < Chef::Resource::Package

      def initialize(name, run_context=nil)
        super
        @resource_name = :slackpkg_package
        @provider = Chef::Provider::Package::Slackpkg
      end

    end
  end
end
