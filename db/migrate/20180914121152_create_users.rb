class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string :name, null: false, default: ''
      t.jsonb :preferences, null: false, default: '{}'
      t.timestamps
    end

    User.create!({
      name: 'Captain Learn',
      preferences: {
        languages: ['ruby', 'javascript'],
        newsletter_opt_in: true,
        life_goals: [
          {
            priority: 1,
            text: 'Learn jsonb'
          },
          {
            priority: 2,
            text: 'More houseplants'
          }
        ]
      }
    })
  end

  def down
    drop_table :users
  end
end
