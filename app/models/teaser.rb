class Teaser < ActiveRecord::Base
   validates_format_of :email, :with => 
  /\A([^@\s]+)@tufts.edu\Z/i, :on => :create
end
