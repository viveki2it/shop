require "bundler/capistrano"
set(:whenever_command) { "RAILS_ENV=#{rails_env} bundle exec whenever" }
require "whenever/capistrano"
require 'sidekiq/capistrano'

server "som-production.shopofme.com", :web, :app, :db, primary: true

set :rails_env, :production
set :rails_env_variant, :ldn
set :application, "som_#{rails_env}_#{rails_env_variant}"

set :user, "deploy"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

# share uploads, because we're badass and don't use s3.
set :shared_children, shared_children + %w{public/uploads}

set :scm, "git"
set :repository, "git@bitbucket.org:TalkingQuickly/shop-of-me.git"
set :branch, "develop"
set :default_environment, {
      'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
    }

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    # make the config dir
    run "mkdir -p #{shared_path}/config"

    # put the config files into shared
    template "config/deploy/#{rails_env}_#{rails_env_variant}_resources/nginx.conf.erb", "#{shared_path}/config/nginx.conf"
    template "config/deploy/#{rails_env}_#{rails_env_variant}_resources/unicorn_init.sh.erb", "#{shared_path}/config/unicorn_init.sh"
    template "config/deploy/#{rails_env}_#{rails_env_variant}_resources/log_rotation.erb", "#{shared_path}/config/log_rotation"
    template "config/deploy/#{rails_env}_#{rails_env_variant}_resources/monit.erb", "#{shared_path}/config/monit"
    template "config/deploy/#{rails_env}_#{rails_env_variant}_resources/unicorn.rb.erb", "#{shared_path}/config/unicorn.rb"
    
    # make the unicorn init script executable
    sudo "chmod +x #{shared_path}/config/unicorn_init.sh"

    # link the config files to the shared config
    sudo "ln -nfs #{shared_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{shared_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    sudo "ln -nfs #{shared_path}/config/log_rotation /etc/logrotate.d/#{application}"
    sudo "ln -nfs #{shared_path}/config/monit /etc/monit/conf.d/#{application}.conf"

    # create an example database.yml file
    put File.read("config/deploy/#{rails_env}_#{rails_env_variant}_resources/database.example.yml"), "#{shared_path}/config/database.example.yml"
    
    puts "Now edit the config files in #{shared_path}."
  end

  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end


