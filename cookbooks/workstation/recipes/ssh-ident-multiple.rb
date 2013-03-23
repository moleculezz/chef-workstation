# TODO: currently only creates personal identity, need to make it more dynamic in the future

directory "#{home}/.ssh/identities" do
  user u["id"]
  group u["id"]
  mode "0700"
end

directory "#{home}/.ssh/identities/personal" do
  user u["id"]
  group u["id"]
  mode "0700"
end

execute "copy_ids" do
  command "cp #{home}/.ssh/id_rsa* #{home}/.ssh/identities/personal"
  creates "#{home}/.ssh/identities/personal/id_rsa"
end

