class User < ApplicationRecord
  store_accessor :preferences, :languages, :life_goals, :newsletter_opt_in

  validates :languages, presence: true, unless: Proc.new { |u| u.languages.is_a?(Array) }
end
