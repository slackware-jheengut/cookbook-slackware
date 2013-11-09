#
# Cookbook Name:: slackware
# Recipe:: default
#


slackpkg_package "htop" do
    action :install
end

package "htop" do
    action :install
end


service "httpd" do
    action [:stop, :disable]
end

service "httpd" do
    action [:start, :enable]
end
