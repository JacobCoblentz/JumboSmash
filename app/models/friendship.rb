class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'

  validates_presence_of :user_id, :friend_id

  def self.request(requesting_user, requested_user)
    if requesting_user == requested_user
      return 'failed'
    end

    f1 = find_by_user_id_and_friend_id(requested_user.id, requesting_user.id)
    f2 = find_by_user_id_and_friend_id(requesting_user.id, requested_user.id)

    if f1 and f2
      f1.status = 'matched'
      f2.status = 'matched'
      MatchMaker.make_match requesting_user
      MatchMaker.make_match requested_user
      retv = 'matched'
    else
      f1 = new(:user => requested_user, :friend => requesting_user, :status => 'pending')
      f2 = new(:user => requesting_user, :friend => requested_user, :status => 'requested')
      retv = 'sent'
    end

    transaction do
      f1.save
      f2.save
    end

    return retv
  end

end
