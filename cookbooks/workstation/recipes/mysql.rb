connection_info = {:host => "localhost", :user => "root", :password => node['mysql']['server_root_password']}

# create a mysql user but grant no privileges
mysql_database_user node["workstation"]["mysql_user"] do
  connection connection_info
  password node["workstation"]["mysql_pass"]
  action :create
end
