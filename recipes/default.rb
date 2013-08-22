# --- Install packages we need ---
packages = %w(make autoconf bison libxml2 libxml2-dev libcurl3 libcurl4-gnutls-dev libmagic-dev)

packages.each do |p|
    package p
end

# package 'php5-fpm'
# package 'php5'
# package 'php5-cli'
# package 'php-pear'
# package 'phpunit'

# cookbook_file "/php-5.5.tgz" do
#     source "php-5.5.tgz"
#     mode "0777"
# end

# execute "Unpack PHP" do
#    command "cd / && tar -xzf php-5.5.tgz"
# end

remote_file "/usr/src/php-5.5.2.tar.bz2" do
    source "http://us3.php.net/get/php-5.5.2.tar.bz2/from/us2.php.net/mirror"
    mode "0777"
end

execute "Expand PHP tarball" do
    command "cd /usr/src && sudo tar -xvf php-5.5.2.tar.bz2"
end

execute "Configure PHP" do
    command "cd /usr/src/php-5.5.2 && ./configure --prefix=/usr --sysconfdir=/etc --with-config-file-path=/etc --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-opcache --enable-mbstring --enable-mbregex --with-mysqli --with-openssl --with-curl --with-zlib"
end

execute "Build & Install PHP" do
    command "cd /usr/src/php-5.5.2 && make && make test && sudo make install"
end

execute "Copy PHP-FPM service config" do
    command = "sudo cp /usr/src/php-5.5.2/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && sudo chmod 755 /etc/init.d/php-fpm && sudo update-rc.d php-fpm defaults"
end

cookbook_file "/etc/php-fpm.conf" do
    source "php-fpm.conf"
    mode "0777"
end

execute "Create PHP log directories" do
    command "sudo mkdir /var/log/php-fpm && sudo mkdir /var/log/php"
end

execute "Install PECL_HTTP and XDebug" do
    command "sudo pecl update_channels && sudo pecl install pecl_http xdebug"
end

execute "Install PHPUnit" do
    command "sudo pear upgrade pear && pear channel-discover pear.phpunit.de && sudo pear channel-discover components.ez.no && sudo pear channel-discover pear.symfony.com && sudo pear install --alldeps phpunit/PHPUnit"
end

cookbook_file "/etc/php.ini" do
    source "xdebug-php.ini"
    mode "0777"
end

execute "start-php5-fpm" do
  command "/etc/init.d/php5-fpm start"
end
