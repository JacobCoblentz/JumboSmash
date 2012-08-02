require 'eset'

class EncryptedList < ActiveRecord::Base
  belongs_to :user
  serialize :pending,  ESetCoder.new
  serialize :requests, ESetCoder.new
  serialize :matched,  ESetCoder.new

  # Public: Add a person to this users list of pending requests
  #
  # their_id - The user id of the person who requested "friendship"
  #
  # Returns :pending or :matched depending on if this user has friend requested
  def add_pending(their_id, key)
    unlock_sets key

    status = :failed
    if requests.set.delete? their_id
      matched.set.add their_id
      return :matched
    else # this user has not friend requested them
      pending.set.add their_id
      return :pending
    end

    return status
  end

  # Public: Add a person to this users list of people this user has friend requested
  #
  # their_id - The user id of the person who has been friend requested
  #
  # Returns :requested or :matched depending on if this user has been requested by them
  def add_request(their_id, key)
    unlock_sets key

    status = :failed
    if pending.set.delete? their_id
      matched.set.add their_id
      status = :matched
    else # this user has not been friend requested by them
      requests.set.add their_id
      status = :requested
    end

    status
  end

  # Public: Remove a previously made request.
  # 
  # their_id - The user id of the person who was requested who now must be removed.
  # 
  # Returns nothing important..... yet.
  def remove(their_id, key)
    unlock_sets key

    [:pending, :requests, :matched].each do |s|
      s.set.delete their_id
    end
  end

  def unlock_sets(key)
    [:pending, :requests, :matched].each do |s|
      self[s].key ||= key
    end
  end
end
