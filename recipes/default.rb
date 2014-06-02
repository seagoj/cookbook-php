%w(make autoconf bison libxml2 libxml2-dev libcurl3 libcurl4-gnutls-dev libmagic-dev curl firebird2.5-classic-common firebird2.5-common firebird2.5-common-doc firebird2.5-server-common firebird2.5-superclassic libfbclient2 libfbembed2.5 libib-util libxslt-dev).each do |p|
    package p
end

cookbook_file "#{node[:php][:source_dir]}/#{node[:php][:deb_file]}" do
    owner node[:php][:user]
    group node[:php][:group]
    source node[:php][:deb_file]
    mode 00755
end

execute "Install PHP from Debian" do
    cwd node[:php][:source_dir]
    user node[:php][:user]
    command "dpkg -i #{node[:php][:deb_file]}"
end

cookbook_file "#{node[:php][:config_dir]}/php-fpm.conf" do
    owner node[:php][:user]
    group node[:php][:group]
    source "php-fpm.conf"
    mode 00755
end

#cookbook_file "#{node[:php][:extensions_dir]}/interbase.so" do
#    owner node[:php][:user]
#    group node[:php][:group]
#    source "interbase.so"
#    mode 00755
#end

cookbook_file "#{node[:php][:config_dir]}/php.ini" do
    owner node[:php][:user]
    group node[:php][:group]
    source "xdebug-php.ini"
    mode 00755
end

cookbook_file "/etc/init.d/php-fpm" do
    owner node[:php][:user]
    owner node[:php][:group]
    source "init.d.php-fpm"
    mode 00755
end

directory "#{node[:php][:log_dir]}/php-fpm" do
    owner node[:php][:user]
    group node[:php][:group]
end

directory "#{node[:php][:log_dir]}/php" do
    owner node[:php][:user]
    group node[:php][:group]
end

execute "Install PECL_HTTP & XDebug" do
    user "root"
    command "pecl update_channels && pecl install pecl_http xdebug"
end

service "php-fpm" do
    supports :status => true, :restart=>true, :reload=>true
    action [:enable, :restart]
end
