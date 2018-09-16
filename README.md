# Learn about jsonb in Postgres & Rails

`jsonb` is a data type available in Postgres 9.4+.

It offers some useful additional operators for your database queries.

## This project requires:

* Ruby 2.3.7
* Rails 5.2.1
* Postgres 9.5.10

## To get this project running on your machine:

```bash
  $ git clone git@github.com:louiseswift/learn_jsonb.git
  $ cd learn_jsonb

  # check your Ruby and Postgres versions and install the required versions,
  # if they aren't already on your machine
  $ ruby -v
  $ postgres --version

  $ gem install bundle # if you don't already have bundle installed
  $ bundle
  $ rake db:create && rake db:migrate
  $ rails s
```

## To start working with jsonb:

1. Open the project's user migration file in `./db/migrate/` to see how a jsonb attribute is added to a model, and how to create records for that model

2. In your terminal, open a new terminal tab to run:
    ```bash
      $ rails console
    ```
    And then once the console is running:
    ```ruby
      User.first
      User.first.preferences
    ```

3. 📝 Create a new user record in your database, with some different preferences data

4. Open up `./app/models/users.rb` to see how to use `store_accessor` on a model to make its JSON attributes available as properties via dot notation, and how it can help keep validations tidy

5. To use these accessible properties, try the following in your console:
    ```ruby
      User.first.languages
      User.first.life_goals

      User.first.update(languages: ['ruby', 'javascript', 'doggo'])
    ```

6. For further manipulation of jsonb values, it can be useful to write custom queries that are executed as follows:
    ```ruby
      p = ActiveRecord::Base.establish_connection
      c = p.connection
      results = c.execute('SELECT * FROM users;')
      results.each { |result| puts result }
    ```

7. A query that will allow us to create or update values within a jsonb attribute is:
    ```sql
      jsonb_set(target jsonb, path text[], new_value jsonb, [create_missing boolean])
    ```
    We could use this to change 'doggo' to 'catto' in our first user's languages array:
    ```ruby
      p = ActiveRecord::Base.establish_connection
      c = p.connection
      sql = 'UPDATE users SET preferences = jsonb_set(preferences, \'{newsletter_opt_in}\', \'false\', FALSE) WHERE id = 1;'
      c.execute(sql)
      User.find(1).newsletter_opt_in # to confirm
    ```
    Or we could delete the third language in their preferences:
    ```ruby
    p = ActiveRecord::Base.establish_connection
    c = p.connection
    sql = 'UPDATE users SET preferences = preferences #- \'{languages,2}\' WHERE id = 1;'
    c.execute(sql)
    User.find(1).languages # to confirm
    ```

8. To query records by values in a jsonb attribute the `@>` operator asks whether the left-hand JSON value contains the right-hand JSON value in its top level:
    ```ruby
      language_json = { languages: [ 'javascript' ] }.to_json
      users = User.where('preferences @> ?', language_json)
    ```

9. 📝 Add a new life goal to any user
  <details>
    <summary>Answer </summary>
      
    ```ruby
      goal_json = { "text": "Play the drums", "priority": 3, "complete": false }.to_json
      sql = "UPDATE users SET preferences = jsonb_set(preferences, '{life_goals,2}', '#{goal_json}', TRUE) WHERE id = 1;"
    ```
  </details>

10. 📝 Find a user whose life_goals include 'Learn jsonb', and update that goal to be complete
  <details>
    <summary>Answer </summary>
      
    ```ruby
      life_goal_json = { life_goals: [ { text: 'Learn jsonb' } ] }.to_json
      user = User.where('preferences @> ?', life_goal_json).first

      updated_goals_json = user.life_goals.map do |goal|
        goal['text'] == 'Learn jsonb' ? goal.tap { |goal| goal['complete'] = true } : goal
      end.to_json

      sql = "UPDATE users SET preferences = jsonb_set(preferences, '{life_goals}', '#{updated_goal_json}', FALSE) WHERE id = #{user.id};"
    ```
  </details>
