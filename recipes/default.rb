# --- Install packages we need ---
packages = %w(make autoconf bison libxml2 libxml2-dev libcurl3 libcurl4-gnutls-dev libmagic-dev)

packages.each do |p|
    package p
end

commands = {
    "Expand PHP tarball" => [
        "cd /usr/src",
        "sudo tar -xvf php-5.5.2.tar.bz2"
    ],
    "Configure PHP" => [
        "cd /usr/src/php-5.5.2",
        "./configure --prefix=/usr --sysconfdir=/etc --with-config-file-path=/etc --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-opcache --enable-mbstring --enable-mbregex --with-mysqli --with-openssl --with-curl --with-zlib"
    ],
    "Build & Install PHP" => [
        "cd /usr/src/php-5.5.2",
        "make",
        "make test",
        "sudo make install"
    ],
    "Copy PHP-FPM service configuration" => [
        "sudo cp /usr/src/php-5.5.2/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm",
        "sudo chmod 755 /etc/init.d/php-fpm",
        "sudo update-rc.d php-fpm defaults"
    ],
    "Create PHP log directories" => [
        "sudo mkdir /var/log/php-fpm",
        "sudo mkdir /var/log/php"
    ],
    "Install PECL_HTTP & XDebug" => [
        "sudo pecl update_channels", 
        "sudo pecl install pecl_http xdebug"
    ],
    "Install PHPUnit" => [
        "sudo pear upgrade pear",
        "pear channel-discover pear.phpunit.de",
        "sudo pear channel-discover components.ez.no",
        "sudo pear channel-discover pear.symfony.com",
        "sudo pear install --alldeps phpunit/PHPUnit"
    ],
    "Start PHP-FPM Service" => [
        "/etc/init.d/php-fpm start"
    ]
};

remote_file "/usr/src/php-5.5.2.tar.bz2" do
    source "http://us3.php.net/get/php-5.5.2.tar.bz2/from/us2.php.net/mirror"
    mode "0777"
end

cookbook_file "/etc/php-fpm.conf" do
    source "php-fpm.conf"
    mode "0777"
end

cookbook_file "/etc/php.ini" do
    source "xdebug-php.ini"
    mode "0777"
end

commands.each do |name, steps|
    execute "#{name}" do
        string = steps.join(' && ')
        puts string
        command "#{string}"
    end
end
        
