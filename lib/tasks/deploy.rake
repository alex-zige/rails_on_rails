namespace :rails_on_rails do
  # http://docs.aws.amazon.com/opsworks/latest/APIReference/Welcome.html
  # bundle exec rake rails_on_rails:deploy[rails_on_rails,true]
  task :deploy, [:stack, :migrate]  => :environment  do |t, args|

    args.with_defaults(:stack => 'rails-on-rails-staging', :migrate => false)
    puts "Running deploy against stack: '#{args[:stack]}', with migrate: '#{args[:migrate]}'"

    # Instantiate OpsWorks client
    client = AWS::OpsWorks::Client.new({access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']})

    # Get the stack based on the name
    response = client.describe_stacks()
    stack = response.stacks.find { |stack| stack.name == args[:stack] }

    # A little basic - only deploy to the first instance on the stack
    response = client.describe_instances({stack_id: stack.stack_id})
    instance = response.instances.first

    # A little basic - only deploy to the first app
    response = client.describe_apps({stack_id: stack.stack_id})
    app = response.apps.last

    puts "Requesting deploy of app '#{app.name}' to instance '#{instance.hostname}' on stack '#{stack.name}'"
    options = {
      stack_id: stack.stack_id,
      app_id: app.app_id,
      instance_ids: [instance.instance_id],
      command: {
        name: 'deploy'
      },
      comment: 'Automated deployment'
    }

    if args[:migrate] == 'true'
      enable_migration = {args:{"migrate" => ["true"]}}
      options[:command].merge! enable_migration
    end
    client.create_deployment(options)

    #notifying on hipchat
    message = "Deploying '#{app.name}' to instance '#{instance.hostname}' on stack '#{stack.name}', this may take a while..."
    uri = URI.parse('http://api.hipchat.com/v1/rooms/message')
    response = Net::HTTP.post_form(uri, {
      'auth_token' => ENV['HIPCHAT_TOKEN'],
      'room_id' => ENV['HIPCHAT_ROOM'],
      'message' => message,
      'from' => 'Deploy Bot',
      'message_format' => 'text'
    })

    puts "Done!"
  end

end
