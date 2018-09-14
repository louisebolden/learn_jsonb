class User < ApplicationRecord
  store_accessor :preferences, :languages, :life_goals, :newsletter_opt_in
end
