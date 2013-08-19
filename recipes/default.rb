# --- Install packages we need ---
package 'php5-fpm'
package 'php5'
package 'php5-cli'
package 'php-pear'

execute "start-php5-fpm" do
  command "/etc/init.d/php5-fpm start"
end
