require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'

set :user, 'www'
set :domain, '5.9.98.165'
set :deploy_to, '/home/www/apps/pastekitten'
set :repository, 'git@github.com:localhots/pastekitten.git'
set :branch, 'master'
set :rbenv_path, '/usr/local/rbenv'
set :app_path, ->{ "#{deploy_to}/#{current_path}" }

set :shared_paths, ['config/database.yml', 'config/syntax.yml']

task :environment do
  invoke 'rbenv:load'
  queue  'echo "-----> Hacking Bundler"'
  queue! 'export PATH="/usr/local/rbenv/shims:$PATH"'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/syntax.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/syntax.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke 'git:clone'
    invoke 'deploy:link_shared_paths'
    invoke 'bundle:install'
    invoke 'assetpack:build'

    to :launch do
      invoke 'unicorn:restart'
    end
  end
end

namespace :assetpack do
  desc 'Procompile assets'
  task :build do
    queue 'echo "-----> Precompile assets"'
    queue! %Q{
      cd #{app_path}
      bundle exec rake assetpack:build
    }
  end
end

namespace :unicorn do
  set :unicorn_pid, "/tmp/pastekitten.unicorn.pid"

  desc "Start unicorn"
  task :start => :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! %Q{
      cd #{app_path}
      bundle exec unicorn -c #{app_path}/config/unicorn.rb -E production -D
    }
  end

  desc "Stop unicorn"
  task :stop do
    queue 'echo "-----> Stop Unicorn"'
    queue! %Q{
      test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    }
  end

  desc "Restart unicorn using 'upgrade'"
  task :restart => :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end
