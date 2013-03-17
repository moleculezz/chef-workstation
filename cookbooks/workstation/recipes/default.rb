include_recipe "users"

begin
  wk = data_bag_item("apps","workstation")
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

wk['packages'].each do |p|
  package p do
    action :install
  end
end
