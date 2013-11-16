#
# Cookbook Name:: slackware
# Library:: provider_package_slackpkg
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

require 'chef/provider/package'
require 'chef/mixin/command'
require 'chef/resource/package'
require 'chef/mixin/get_source_from_package'

class Chef
  class Provider
    class Package
      class Slackpkg < Chef::Provider::Package
        include Chef::Mixin::GetSourceFromPackage

        def whyrun_supported?
          false
        end

        def load_current_resource
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)

          @slackpkg_status = popen4("/usr/sbin/slackpkg -batch=on -dialog=off -default_answer=yes search '#{@new_resource.name}-[0-9].*'") do |pid, stdin, stdout, stderr|
            stdout.each do |line|
              case line
              when /(.*)\s-\s#{@new_resource.name}-([\w\d_.]+)-.*/
                Chef::Log::debug("#{@new_resource} version #{$2} available")
                  @new_resource.version($2)
              end
            end
          end

          Chef::Log.debug("#{@new_resource} checking install state")
          status = popen4("find /var/log/packages -name '#{@current_resource.package_name}-*' -printf '%f\n'") do |pid, stdin, stdout, stderr|
            stdout.each do |line|
              case line
              when /#{@current_resource.package_name}-([\w\d_.]+).*/
                Chef::Log.debug("#{@new_resource} current version is #{$1}")
                @current_resource.version($1)
              end
            end
          end

          @current_resource
        end
        
        #TODO: check that slackpkg is callable
        def define_resource_requirements
          super
        end

        def install_package(name, version)
          run_command_with_systems_locale(
            :command => "slackpkg -batch=on -dialog=off -default_answer=yes install #{name}"
          )
        end

        alias_method :upgrade_package, :install_package

        def remove_package(name, version)
          run_command_with_systems_locale(
            :command => "slackpkg -batch=on -dialog=off -default_answer=yes remove #{name}"
          )
        end

      end
    end
  end
end

# vim: set sw=2 ts=2 sts=2 et :
