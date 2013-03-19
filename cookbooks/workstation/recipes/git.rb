begin
  u = data_bag_item('users', Etc.getlogin)
rescue Net::HTTPServerException => e
  Chef::Application.fatal!('#{cookbook_name} could not load data bag; #{e}')
end

u['files'].each do |name, file|
  template "#{ENV['HOME']}/#{name}" do
    source file['source']
    owner u['id']
    mode file['mode']
    variables(
      :name => u['comment'],
      :email => u['email']
    )
  end
end
