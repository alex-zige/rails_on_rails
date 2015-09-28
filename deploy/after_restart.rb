# If using opsworks, requires ENV Vars to be set on App Layer.
# Format please follow, .env.sample
#

stack_name = node[:opsworks][:stack][:name]
ip = node[:opsworks][:instance][:ip]

node[:deploy].each do |application, deploy|

  ########### Hipchat Notification

  Chef::Log.info("Getting commit info for app #{application}")
  current_dir = "#{deploy[:deploy_to]}/current"
  previous_deploy_dir = "#{deploy[:deploy_to]}/releases/" + Dir.entries("#{deploy[:deploy_to]}/releases").sort[-2]
  branch = deploy[:scm][:revision] || 'master'

  commit_sha_cmd = Mixlib::ShellOut.new('git log -1 --format="%h"', {
    :cwd => current_dir
  })

  commit_sha_cmd.run_command
  commit_sha = commit_sha_cmd.stdout.chomp

  previous_commit_sha_cmd = Mixlib::ShellOut.new('git log -1 --format="%h"', {
    :cwd => previous_deploy_dir
  })

  previous_commit_sha_cmd.run_command
  previous_commit_sha = previous_commit_sha_cmd.stdout.chomp

  Chef::Log.info("Getting changes between #{commit_sha} and #{previous_commit_sha} (from #{previous_deploy_dir})")
  repository_path = deploy[:scm][:repository]
  match = /git@github.com:(\w+)\/([\w-]+).git/.match(repository_path) #regex
  if match
    github_base = "https://github.com"
    github_account = match[1]
    github_repo = match[2]
    github_repo_commit_base_url = "#{github_base}/#{github_account}/#{github_repo}/commit"
    github_branch_url = "#{github_base}/#{github_account}/#{github_repo}/commits/#{branch}"
    Chef::Log.info("github github_branch_url #{github_branch_url}")
    changes_cmd = Mixlib::ShellOut.new("git log #{commit_sha}...#{previous_commit_sha} --format=\"- %an: %s (<a href='#{github_repo_commit_base_url}/%H'>%h</a>)<br/>\"", {
      :cwd => current_dir
    })
    message = "Commit #{commit_sha} from branch <a href=\"#{github_branch_url}\">#{branch}</a> was deployed to stack #{stack_name} (<a href=\"http://#{ip}\">#{ip}</a>). Changes: <br/>"
    format = 'html'
  else
    changes_cmd = Mixlib::ShellOut.new("git log #{commit_sha}...#{previous_commit_sha} --format=\"[%h] %an: %s\"", {
      :cwd => current_dir
    })
    message = "Commit #{commit_sha} from branch '#{branch}' was deployed to stack #{stack_name} (http://#{ip}). Changes:\n"
    format = 'text'
  end

  changes_cmd.run_command
  changes = changes_cmd.stdout.chomp

  Chef::Log.info("Commits Changes: #{changes}")
  message += changes

  #http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-extend-hooks.html
  hipchat_token = new_resource.environment["HIPCHAT_TOKEN"]
  hipchat_room = new_resource.environment["HIPCHAT_ROOM"]

  uri = URI.parse('http://api.hipchat.com/v1/rooms/message')
  response = Net::HTTP.post_form(uri, {
    'auth_token' => hipchat_token,
    'room_id' => hipchat_room,
    'message' => message,
    'from' => 'Deploy Bot',
    'message_format' => format
  })

end


########### CRONTAB
# Use when cron-level of scheduler is needed

# rails_env = new_resource.environment["RAILS_ENV"]

# crontab_lines = []
# #need path to ruby
# crontab_lines << "PATH=/usr/local/bin:$PATH"
# crontab_lines << "0 * * * * /bin/bash -l -c 'cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake schedule:hourly_runner --silent >> #{release_path}/log/cron_log.log 2>&1'"
# crontab_lines << "8 0 * * * /bin/bash -l -c 'cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake schedule:daily_runner --silent >> #{release_path}/log/cron_log.log 2>&1'"

# Chef::Log.info("Update Crontable")
# Chef::Log.info("With: #{crontab_lines.inspect}")
# execute "crontab update" do
#   cwd release_path
#   command "echo -e \"#{crontab_lines.join('\n')}\" >> cronjob && crontab cronjob && rm cronjob"
#   user 'deploy'
# end


########### NOTIFY RollBar
# Use rollbar as notificatin handler

# rails_env = new_resource.environment["RAILS_ENV"]
# roll_bar_access_token = new_resource.environment["ROLLBAR_ACCESS_TOKEN"]
# git_rev=`git log -n 1 --pretty=format:"%H"`
# system "curl https://api.rollbar.com/api/1/deploy/  -F access_token=#{roll_bar_access_token}  -F environment=#{rails_env} -F revision=#{git_rev} -F local_username=deploy"




