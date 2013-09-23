# Chef Recipe to install composer and run `composer install`
include_recipe 'php'
package 'git'

remote_file "/usr/local/bin/composer" do
    source "https://getcomposer.org/composer.phar"
    mode 00755
end

execute "Installing composer packages" do
    cwd node[:php][:doc_root]
    user node[:php][:user]
    command "composer install"
end

