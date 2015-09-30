# Getting start

This project is used at boilerplate for bootstraping rails project.
It includes quite a lot of best practices over the years and tailored for our AWS Opswork deployment life cycle.

##Clone project

```
git clone git@github.com:TouchtechLtd/rails_on_rails.git

```
##Config gemset

Modify ``.ruby-gemset`` change ``rails_on_rails`` to your project

```
your-project-name

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
>
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

Requires MySQL (5.6) to be installed and running.

note: if your app requires mb4_utf8 encoding, please modify the following:

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

####Command Line Deploys
To deploy with the command line, you can use the leapingtiger:deploy rake task:

```
rake 'your_project_name:deploy['your-project-name-staging',true]'
```

Parameter 1 is the stack name (defaults to 'rails-on-rails-staging')

Parameter 2 is if the deploy will migrate the database (defaults to false)


##API Spec

[API references]