# --- Install packages we need ---
package 'php5-cgi'

# --- Deploy a configuration file ---
# For longer files, when using 'content "..."' becomes too
# cumbersome, we can resort to deploying separate files:
cookbook_file '/etc/init.d/php-fastcgi' do
  source "php-fastcgi.d"
  mode "0777"
end

execute "start-php-fastcgi" do
  command "/etc/init.d/php-fastcgi start"
end

execute "install-php-as-service" do
  command "update-rc.d php-fastcgi defaults"
end