begin
  u = data_bag_item("users", Etc.getlogin)
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

node.default["nginx"]["default_site_enabled"] = false
include_recipe "nginx"

directory "/var/www/nginx-default" do
  owner u["id"]
  group node["nginx"]["group"]
  mode "0755"
  recursive true
end

