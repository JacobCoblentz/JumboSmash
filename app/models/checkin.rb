class Checkin < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :location, :description, :latitude, :longitude
  
  def friends_of (user)
    
  end
end
