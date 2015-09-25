# Setup

## Database

Requires MySQL (5.6) to be installed and running.

notes: if the app is requires mb4_utf8 encoding, plesae enable

``
  config/database.yml
  > encoding: utf8mb4
  > collation: utf8mb4_unicode_ci
``

and ``config/initializers/mysql_utf8mb4.rb``


## App

Make a copy of the file `.env.sample` called `.env`

    $ cp .env.sample .env

This is where keys stored in the environment variables are loaded from for
development instances, such as API keys, secrets etc.

If you need to, edit `.env` and add your development credentials.

## Seed data

To load basic seed data
run the rake task (which takes quite some time)

    $ rake db:seed_fu

####Command Line Deploys
To deploy with the command line, you can use the leapingtiger:deploy rake task:

```
rake 'leapingtiger:deploy[leaping-tiger-staging,true]'
```

Parameter 1 is the stack name (defaults to 'rails-on-rails-staging')

Parameter 2 is if the deploy will migrate the database (defaults to false)


##API Spec

[API references]