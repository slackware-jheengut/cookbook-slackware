#
# Cookbook Name:: slackware
# Library:: resource_slackpkg
#
# Copyright 2013 Olivier Biesmans
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
