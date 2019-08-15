class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
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
    most_full_hood = nil
    most_res_per_listing = 0
    self.all.each do |hood|
      num_listings = hood.listings.length
      num_res = 0
      hood.listings.each do |listing|
        num_res += listing.reservations.length
      end
      if num_listings != 0 
        res_per_listing = num_res/num_listings
        if res_per_listing > most_res_per_listing
          most_res_per_listing = res_per_listing
          most_full_hood = hood
        end
      end
    end
    most_full_hood
  end

  def self.most_res 
    most_res_hood = nil
    most_res = 0
    self.all.each do |hood|
      num_listings = hood.listings.length
      num_res = 0
      hood.listings.each do |listing|
        num_res += listing.reservations.length
      end
      if num_res > most_res
        most_res = num_res
        most_res_hood = hood
      end
    end
    most_res_hood
  end

end
