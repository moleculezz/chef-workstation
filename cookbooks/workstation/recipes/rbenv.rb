begin
  u = data_bag_item("users", Etc.getlogin)
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

node.default["rbenv"]["group_users"] = ["#{u['id']}"]

include_recipe "rbenv"
include_recipe "rbenv::ruby_build"

#rbenv_ruby "2.0.0.p0" do
#  #global true
#end
