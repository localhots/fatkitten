working_directory '/home/www/apps/pastemaster/current'
worker_processes 2
timeout 10

listen '/tmp/pastemaster.unicorn.sock', backlog: 64
pid '/tmp/pastemaster.unicorn.pid'

stderr_path '/dev/null'
stdout_path '/dev/null'
