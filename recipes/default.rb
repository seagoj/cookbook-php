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

execute "expand" do
    command "cd /usr/src && sudo tar -xvf php-5.5.2.tar.bz2"
end

execute "configure" do
    command "cd /usr/src/php-5.5.2 && ./configure --prefix=/usr --sysconfdir=/etc --with-config-file-path=/etc --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-opcache --enable-mbstring --enable-mbregex --with-mysqli --with-openssl --with-curl --with-zlib"
end

execute "make" do
    command "cd /usr/src/php-5.5.2 && make && make test && sudo make install"
end

execute "phpunit" do
    command "sudo pear upgrade pear && pear channel-discover pear.phpunit.de && sudo pear channel-discover components.ez.no && sudo pear channel-discover pear.symfony.com && sudo pear install --alldeps phpunit/PHPUnit"
end

execute "xdebug" do
    command "sudo pecl install xdebug"
end

cookbook_file "/etc/php.ini" do
    source "xdebug-php.ini"
    mode "0777"
end

execute "start-php5-fpm" do
  command "/etc/init.d/php5-fpm start"
end
