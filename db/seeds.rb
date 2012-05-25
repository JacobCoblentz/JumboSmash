require 'csv'

people_csv = File.read("#{Rails.root}/db/people.csv")
people = CSV.parse(people_csv)
people.each do |row|
  user = Whitelist.new
  user.email = (row.last)? row.last.downcase : ''
  user.name = "#{row[2]} #{row[1]}"
  user.gender = (row.first.start_with? 'Mr.') ? 'm' : 'f'
  if user.save
    puts "Seeded #{row.last} as #{user.gender}"
  else
    puts "Unable to seed #{row.last}"
  end
end

people_csv = File.read("#{Rails.root}/db/people.csv")
people = CSV.parse(people_csv)
people.each do |row|
  # there should be a more sensible default starting password for each user.
  # it should not be the same for all users.
  user = User.create!(:email => row.last.downcase, :password => "testing")
  if user.save
    puts "New user #{user.name}"
  else
    puts "#{user.name} could not be created"
  end
end
