begin
  u = data_bag_item("users", Etc.getlogin)
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

node.default["php"]["packages"] = ["php5-fpm", "php5-cli", "php-pear"]
node.default["workstation"]["php-fpm"]["directives"]["cgi.fix_pathinfo"] = "0" 
node.default["workstation"]["web"] = "sites"
include_recipe "php"

template "/etc/php5/fpm/php.ini" do
  source "php-fpm.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, "service[php5-fpm]", :immediately
end

template "#{node[:nginx][:dir]}/sites-available/#{node[:workstation][:web]}" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :name => "brain",
    :root => "/var/www/sites"
  )
end

nginx_site "#{node[:workstation][:web]}" do
  enable true
end

directory "/var/www/#{node[:workstation][:web]}" do
  owner u["id"]
  group node["nginx"]["group"]
  mode "0755"
end

service "php5-fpm" do
  supports :status => true, :restart => true, :reload => true
  action :start
end
