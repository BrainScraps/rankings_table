class User < ActiveRecord::Base
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  def rating=(new_rating)
    self.sigma = new_rating.sigma
    self.mu = new_rating.mu
  end

  def rating
    Rating.new(self.mu, self.sigma)
  end

  def self.update_ratings(winner, loser)
    new_ratings = g().transform_ratings([[winner],[loser]],[0,1])
    winner.rating = new_ratings[0][0]
    loser.rating = new_ratings[1][0]
  end

  def self.update_ratings!(winner, loser)
    self.update_ratings(winner, loser)
    winner.save!
    loser.save!
  end
end