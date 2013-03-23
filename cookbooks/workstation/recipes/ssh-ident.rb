begin
  u = data_bag_item("users", Etc.getlogin)
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

home = ENV['HOME']

directory node["workstation"]["scripts"] do
  user u["id"]
  group u["id"]
  mode "0755"
end

git "#{node[:workstation][:scripts]}/ssh-ident" do
  repository node["workstation"]["ssh-ident"]["git_repository"]
  reference node["workstation"]["ssh-ident"]["git_revision"]
  user u["id"]
  group u["id"]
  action :sync
end

file "#{home}/.bash_aliases" do
  user u["id"]
  group u["id"]
  mode "0644"
  action :create_if_missing
end

execute "bashrc_alias" do
  user u["id"]
  command "echo \"alias ssh='#{node[:workstation][:scripts]}/ssh-ident/ssh-ident'\" >> #{home}/.bash_aliases"
  not_if "grep ssh-ident #{home}/.bash_aliases"
end
