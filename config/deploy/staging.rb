set :stage, :staging
set :branch, "master"
set :deploy_to, '/var/www/devlits.com/laura.devlits.com/'
set :rvm_ruby, '2.2.0'
set :linked_dirs, %w{log tmp/pids tmp/cache }

set :sidekiq_default_hooks,  true
set :sidekiq_pid,  File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
set :sidekiq_env,  fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
set :sidekiq_log,  File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_options,  nil
set :sidekiq_require, nil
set :sidekiq_tag, nil
set :sidekiq_config, nil
set :sidekiq_queue, nil
set :sidekiq_timeout,  10
set :sidekiq_role,  :app
set :sidekiq_processes,  1

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{current_path}/tmp/pids/puma.state"
set :puma_pid, "#{current_path}/tmp/pids/puma.pid"
set :puma_bind, ["unix:///tmp/sockets/laura.sock"]    #accept array for multi-bind
set :puma_access_log, "#{current_path}/log/puma_error.log"
set :puma_error_log, "#{current_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:stage))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_init_active_record, true
set :puma_preload_app, true

