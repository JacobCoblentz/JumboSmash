ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

PASSWORD = 'testing'
SECRET = Digest::SHA2.base64digest DA_SALT + PASSWORD

# seed the whitelist
people = ['Andrew Purcell', 'Erik Formella', 'Calvin Hopkins']
people.each do |name|
  user = Whitelist.new
  user.email = name.downcase.sub(' ','.') + '@tufts.edu'
  user.name = name
  user.gender = 'm'
  if user.save
    puts "Seeded #{name}"
  else
    puts "Unable to seed #{name}"
  end
end

# seed users
people.each do |name|
  user = User.create!(:email => name.downcase.sub(" ", ".")+"@tufts.edu", :password => PASSWORD)
  if user.save
    puts "Saved #{name}"
  else
    puts "Unable to save #{name}"
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # Add more helper methods to be used by all tests here...
end
