[![Build Status](https://travis-ci.org/alex-zige/rails_on_rails.svg?branch=master)](http://travis-ci.org/alex-zige/rails_on_rails)
[![Code Climate](https://codeclimate.com/github/alex-zige/rails_on_rails/badges/gpa.svg)](https://codeclimate.com/github/alex-zige/rails_on_rails)
[![Test Coverage](https://codeclimate.com/github/alex-zige/rails_on_rails/badges/coverage.svg)](https://codeclimate.com/github/alex-zige/rails_on_rails/coverage)
[![Jion Chat](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/alex-zige/rails_on_rails)

#Getting started 🚀

This project is used as a boilerplate for bootstrapping rails projects.
It includes quite a lot of best practices over the years and tailored for our AWS Opswork deployment life cycle.

#What's in it?
* Base Collection of popular gems and optional gems
* Base User model with basic authentication
* Base API structure with error handling
* Base initializer configurations
* Base Rspec test suite setup with ``factory_girl``
* Base JSON schema validator integrated with rspec
* Best practise to handle env vars
* Base ``after_restart`` and ``after_migrate`` hook for using AWS Opswork for deployment with Chef
* Base deploy tasks for deploying via CLI
* TBC

##Clone project

```
git clone git@github.com:alex-zige/rails_on_rails.git

```

##Config database
```
> cp config/database.yml.sample config/database.yml

```

Modify database.yml


```
development:
  <<: *default
  database: {your-project-name}_dev

staging:
  <<: *default
  database: {your-project-name}_dev_staging

test:
  <<: *default
  database: {your-project-name}_dev_test

```


##Bundle

```
> gem update --system
> gem install bundler
> bundle install

```

##Rename project

```
 > rails g rename:app_to your-project-name
 > cd ..
 > cd your-project-name

```
Notes: make sure your-project-name is the same with ``.ruby-gemset``. otherwise you might need to re-run ``bundle install``install all the gems under correct gemset.


##Utf8bm4 Database

note: if your app requires mb4_utf8 encoding (emoji), please modify the following:

```

  #config/database.yml
  encoding: utf8mb4
  collation: utf8mb4_unicode_ci

```

and ``config/initializers/mysql_utf8mb4.rb``


##Create database

```
 > rake db:create

 > rake db:migrate
```

##Strat rails server

```
 > rails s

```


##Specs

```
 > rspec .

```

##Tweak Deploy tasks

Modify ``lib/tasks/deploy.rake``

replace ``rails_on_rails`` to ``your-project-name``



## Environment Variables

Make a copy of the file `.env.sample` called `.env`

    $ cp .env.sample .env

This is where keys stored in the environment variables are loaded from for
development instances, such as API keys, secrets etc.

If you need to, edit `.env` and add your development credentials.

##Push to github

```
> git remote set-url origin git@github.com:TouchtechLtd/you-commit-rails.git


> git push -u origin

```

##Remove rename gem
Delete ``gem 'rename'`` from your ``Gemfile``

##Enable optional gems
There's a list of pouplar gems listed in gemfile marked as optional. Feel free to enable those if needed.

```
gem "parse-ruby-client"
gem "rake-cors"

```


## Seed data

To load basic seed data
run the rake task (which takes quite some time)

    $ rake db:seed_fu

## Command Line Deploys
To deploy with the command line, you can use the your-project-name:deploy rake task:

```
rake 'your_project_name:deploy['your-project-name-staging',true]'
```

Parameter 1 is the stack name (defaults to 'your-project-name-staging')

Parameter 2 is if the deploy will migrate the database (defaults to false)


#Caveat
If you are using AWS Opswork Stack, please in your Rails App Layer, specifiy the bundler version to be ``1.10.6`` or above and the change will be applied after a new deployment.

By default AWS Rails App layer using the out of dated version ``bundler 1.5.3`` that you would be more likely to run into ``SystemStackError: stack level too deep`` error.


#Authentication

There are open two ways of authentications against the server.

Authentication Token (Sent as a parameter)

You can access the server with URL appended with Access Token

`` $ curl https://xxx/api/v1/users/?authentication_token=AUTHENTICATION-TOKEN``

Authentication Token (Sent in a header)

`` $ curl -H "Authorization:AUTHENTICATION_TOKEN" https://xxx/api/v1/users``

##API Spec

[API references]
