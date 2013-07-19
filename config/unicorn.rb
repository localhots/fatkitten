working_directory '/home/www/apps/pastekitten/current'
worker_processes 2
timeout 10

listen '/tmp/pastekitten.unicorn.sock', backlog: 64
pid '/tmp/pastekitten.unicorn.pid'

stderr_path '/dev/null'
stdout_path '/dev/null'
