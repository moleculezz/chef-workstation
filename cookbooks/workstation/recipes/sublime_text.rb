begin
  u = data_bag_item('users', Etc.getlogin)
  wk = data_bag_item("apps","workstation")
rescue Net::HTTPServerException => e
  Chef::Application.fatal!('#{cookbook_name} could not load data bag; #{e}')
end

user_id = u["id"]

remote_file "/tmp/Sublime Text 2.tar.bz2" do
  source "#{node['workstation']['sublime_text_file']}"
  owner "root"
  group "root"
  mode "0644"
  not_if "which sublime"
  notifies :run, "execute[install_sublime]", :immediately
end

execute "install_sublime" do
  user "root"
  group "root"
  cwd "/tmp"
  command "tar -xf Sublime\\ Text\\ 2.tar.bz2; mv Sublime\\ Text\\ 2 /opt/"
  action :nothing
end

link "/usr/bin/sublime" do
  to '/opt/Sublime Text 2/sublime_text'
end

installed_package_dir = "#{ENV['HOME']}/.config/sublime-text-2/Installed Packages"
package_dir = "#{ENV['HOME']}/.config/sublime-text-2/Installed Packages"
remote_file "#{installed_package_dir}/Package Control.sublime-package" do
  source "https://sublime.wbond.net/Package%20Control.sublime-package"
  owner u["id"]
  group u["id"]
  action :create_if_missing
end



case node['platform']
when "ubuntu"
  installed_package_dir = "#{ENV['HOME']}/.config/sublime-text-2/Installed Packages"
  package_dir = "#{ENV['HOME']}/.config/sublime-text-2/Packages"

  remote_file "#{installed_package_dir}/Package Control.sublime-package" do
    source "https://sublime.wbond.net/Package%20Control.sublime-package"
    owner u["id"]
    group u["id"]
    action :create_if_missing
  end

  wk['sublime_packages'].each do |p|
    git "#{package_dir}/#{p['name']}" do
      repository p["source"]
      reference p["reference"]
      user u["id"]
      group u["id"]
      action :sync
    end
  end

  template "/usr/share/applications/sublime.desktop" do
    source "sublime.desktop.erb"
    owner "root"
    group "root"
    mode "0644"
    action :create_if_missing
  end

  template "#{package_dir}/User/Preferences.sublime-settings" do
    source "Preferences.sublime-settings.erb"
    owner "root"
    group "root"
    mode "0664"
    action :create
  end
end
