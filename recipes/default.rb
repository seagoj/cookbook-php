# --- Install packages we need ---
package 'php5-fpm'

execute "start-php5-fpm" do
  command "/etc/init.d/php5-fpm start"
end