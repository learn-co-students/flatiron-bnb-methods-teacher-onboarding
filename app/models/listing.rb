class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  before_save :make_host
  before_destroy :unmake_host

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  def average_review_rating
    num_reviews = 0.0
    rating_sum = 0.0
    self.reviews.each do |review|
      num_reviews += 1.0
      rating_sum += review.rating
    end
    average_review_rating = rating_sum/num_reviews
  end

  private
  # Makes user a host when a listing is created
  def make_host
    # binding.pry
    unless self.host.host
      self.host.update(:host => true)
    end
  end  

  def unmake_host
    # binding.pry
    if self.host.listings.count <= 1
      self.host.update(:host => false)
    end
  end
end
