# --- Install packages we need ---
%w(make autoconf bison libxml2 libxml2-dev libcurl3 libcurl4-gnutls-dev libmagic-dev curl).each do |p|
    package p
end

remote_file "/usr/src/php-5.5.2.tar.bz2" do
    source "http://us3.php.net/get/php-5.5.2.tar.bz2/from/us2.php.net/mirror"
    mode "0777"
end

execute "Expand PHP tarball" do
    cwd "/usr/src"
    user "root"
    command "tar -xvf php-5.5.2.tar.bz2"
end

execute "Configure PHP" do
    cwd "/usr/src/php-5.5.2"
    user "root"
    command "./configure --prefix=/usr --sysconfdir=/etc --with-config-file-path=/etc --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-opcache --enable-mbstring --enable-mbregex --enable-zip --with-mysqli --with-openssl --with-curl --with-zlib"
end

execute "Build & Install PHP" do
    cwd "/usr/src/php-5.5.2"
    user "root"
    command "make && make test && make install"
end

cookbook_file "/etc/php-fpm.conf" do
    source "php-fpm.conf"
    mode "0777"
end

cookbook_file "/etc/php.ini" do
    source "xdebug-php.ini"
    mode "0777"
end

execute "Copy PHP-FPM service configuration" do
    user "root"
    command "cp /usr/src/php-5.5.2/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod 755 /etc/init.d/php-fpm && update-rc.d php-fpm defaults"
end

execute "Create PHP log directories" do
    user "root"
    command "mkdir /var/log/php-fpm && mkdir /var/log/php"
end

execute "Install PECL_HTTP & XDebug" do
    user "root"
    command "pecl update_channels && pecl install pecl_http xdebug"
end

# execute "Install PHPUnit" do
#     user "root"
#     command "pear upgrade pear && pear channel-discover pear.phpunit.de && pear channel-discover components.ez.no && pear channel-discover pear.symfony.com && pear install --alldeps phpunit/PHPUnit"
# end

remote_file "/usr/local/bin/composer" do
    source "https://getcomposer.org/composer.phar"
    mode "0755"
end

execute "Start PHP-FPM Service" do
    user "root"
    command "/etc/init.d/php-fpm start"
end
