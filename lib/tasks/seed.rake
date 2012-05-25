namespace :seed do

  desc "Undo seed:users"
  task :reset => :environment do
    User.delete_all
    ConnectionQueue.delete_all
    EncryptedList.delete_all
  end

  desc "make sure encrypted lists are there"
  task :lists => :environment do
    users = User.all
    users.each do |u|
      u.force_create_encrypted_list 'testing'
      u.save
    end
  end
  
  desc "Seed some friendships"
  task :friends => [:environment] do
    users = User.all

    secret = Digest::SHA2.base64digest DA_SALT + 'testing'

    users[0].add_request users[1].id, secret
    users[1].add_request users[0].id, secret

    users[3].add_request users[0].id, secret
    users[3].add_request users[1].id, secret
    users[3].add_request users[2].id, secret
    users[3].add_request users[4].id, secret

    users[4].add_request users[2].id, secret
    users[2].add_request users[4].id, secret

    users[1].add_request users[2].id, secret
    users[1].add_request users[5].id, secret

    users.each {|u| 
      u.resolve_queued_connections secret
      u.save
    }
  end
  
end
