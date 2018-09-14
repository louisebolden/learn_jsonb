# Learn about jsonb in Postgres & Rails

`jsonb` is a data type available in Postgres 9.4+.

It offers some useful additional operators for your database queries.

## This project requires:

* Ruby 2.3.7
* Rails 5.2.1
* Postgres 9.5.10

## To get this project running on your machine:

```
  git clone git@github.com:louiseswift/learn_jsonb.git
  cd learn_jsonb

  # check your Ruby and Postgres versions
  ruby -v
  postgres --version

  bundle
  rake db:create && rake db:migrate
  rails s
```

## To start working with jsonb:

1. Open the project's user migration file in `./db/migrate/` to see how a jsonb attribute is added to a model, and how to create records for that model

2. In your terminal, open a new terminal tab to run:
    ```
      $ rails console

      # then in the console:
      User.first
      User.first.preferences
    ```

3. ✏️ Create a new user record in your database, with some different preferences data

4. Open up `./app/models/users.rb` to see how to use `store_accessor` on a model to make its JSON attributes available as properties via dot notation

5. To use these accessible properties, try the following in your console:
    ```

    ```


# TODO:
# Can easily append to/remove from life_goals array via db query?
# What about enforcing/validating structure of jsonb attributes?
