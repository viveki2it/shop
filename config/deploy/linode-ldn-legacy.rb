set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_ruby_string, 'default'
set :rvm_type, :user  # Don't use system-wide RVM

#require "bundler/capistrano"
#require "rvm/capistrano"    
require "bundler/capistrano"
require "whenever/capistrano"

server "176.58.102.52", :web, :app, :db, primary: true

set :application, "shopofme"
set :user, "deploy"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@bitbucket.org:TalkingQuickly/shop-of-me.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} /etc/init.d/nginx restart"
    run "#{try_sudo} /bin/sh -c 'cd /home/deploy/apps/shopofme/current && kill -s QUIT `cat tmp/pids/resque_general_0.pid` && rm -f tmp/pids/resque_general_0.pid; exit 0;'"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/conf/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/monit /etc/monit.d/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.sample.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

        require './config/boot'
        require 'airbrake/capistrano'
