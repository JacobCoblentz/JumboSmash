class Whitelist < ActiveRecord::Base
  class << self
    def include? (email)
      where("email like ?", email).any?
    end
    
    def name_for (email)
       where("email like ?", email).first.name
    end
    
    def gender_for (email)
       where("email like ?", email).first.gender
    end
  end
end
