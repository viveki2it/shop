require "bundler/capistrano"
require 'capistrano/ext/multistage'
set :stages, %w(production_ldn linode-ldn-legacy)
set :default_stage, "production_ldn"

def template(from, to)
    erb = File.read(from)
    put ERB.new(erb).result(binding), to
end