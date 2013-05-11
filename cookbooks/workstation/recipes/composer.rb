if File.exists?("/usr/local/bin/composer")

    execute "update_composer" do
        user "root"
        cwd "/tmp"
        command <<-EOH
            /usr/local/bin/composer self-update
        EOH
    end

else

    execute "install_composer" do
        user "root"
        cwd "/tmp"
        command <<-EOH
            curl -s https://getcomposer.org/installer | php
            mv composer.phar /usr/local/bin/composer
        EOH
    end

end