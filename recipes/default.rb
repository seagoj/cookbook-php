# --- Install packages we need ---
package 'make'
package 'php5-fpm'
# package 'php5'
package 'php5-cli'
package 'php-pear'
package 'phpunit'

execute "phpunit" do
    command "sudo pear upgrade pear && pear channel-discover pear.phpunit.de && sudo pear channel-discover components.ez.no && sudo pear channel-discover pear.symfony.com && sudo pear install --alldeps phpunit/PHPUnit"
end

execute "xdebug" do
    command "sudo pecl install xdebug"
end

cookbook_file "/etc/php5/cli/php.ini" do
    source "xdebug-php.ini"
    mode "0777"
end

execute "start-php5-fpm" do
  command "/etc/init.d/php5-fpm start"end
