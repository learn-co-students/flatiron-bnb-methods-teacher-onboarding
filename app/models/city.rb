class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    all_listings = self.listings
    available_listings = []
    all_listings.each do |listing|
      available = true
      if listing.reservations.empty? != true
        listing.reservations.each do |reservation|
          if (reservation.checkin.to_s < end_date && reservation.checkin.to_s > start_date)  || (reservation.checkout.to_s > start_date && reservation.checkout.to_s < start_date)
            available = false
          end
        end     
      end
      available_listings << listing if available
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    most_full_city = nil
    most_res_per_listing = 0
    self.all.each do |city|
      num_listings = city.listings.length
      num_res = 0
      city.listings.each do |listing|
        num_res += listing.reservations.length
      end
      res_per_listing = num_res/num_listings
      if res_per_listing > most_res_per_listing
        most_res_per_listing = res_per_listing
        most_full_city = city
      end
    end
    most_full_city
  end

  def self.most_res 
    most_res_city = nil
    most_res = 0
    self.all.each do |city|
      num_listings = city.listings.length
      num_res = 0
      city.listings.each do |listing|
        num_res += listing.reservations.length
      end
      if num_res > most_res
        most_res = num_res
        most_res_city = city
      end
    end
    most_res_city
  end
end

