class User < ActiveRecord::Base
  has_many :checkins
  has_one :encrypted_list, :autosave => true, :dependent => :destroy
  has_many :queued_connections, :foreign_key => :user_id, :class_name => 'ConnectionQueue', :order => 'created_at'

  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender

  before_validation :whitelisted
  after_create :generate_keys, :create_encrypted_list

  def last_checkin
    c = checkins.where("created_at > ?", Time.now-6.hours).order("created_at DESC").first
    {latitude: c.latitude, longitude: c.longitude, status: c.description, updated_at: c.updated_at, location: c.location}
  end
  
  def all_friends_checkins
    connections.collect {|c| [c.name, c.last_checkin] }
  end
  
  def get_connections(secret)
    uids = encrypted_list.read_matched_list secret
    User.find uids
  end

  def get_requests(secret)
    uids = encrypted_list.read_requests_list secret
    User.find uids
  end

  def get_pending(secret)
    uids = encrypted_list.read_pending_list secret
    User.find uids
  end

  def resolve_queued_connections(secret)
    connection_map = {}
    queued_connections.each do |qc|
      their_id = qc.decrypt self.private_key, secret
      their_id = Integer(their_id)
      if connection_map[their_id].nil?
        connection_map[their_id] = []
      end
      connection_map[their_id].append qc.message_type.to_sym
    end
    queued_connections.destroy_all

    results = []
    for k,v in connection_map
      case v.last
      when :create
        results.append encrypted_list.add_new_request k, :theirs, secret
      when :destroy
        results.append encrypted_list.remove k, secret
      end
    end
    results
  end

  def add_request(their_id, secret)
    them = User.find their_id
    return 'failed' if String(their_id) == String(self.id) or not them
    resolve_queued_connections(secret)

    status = encrypted_list.add_new_request their_id, :mine, secret
    case status
    when 'added', 'matched'
      send_connection_message their_id, :create
    end
    return status
  end

  def remove_person(their_id, secret)
    them = User.find their_id
    if them and encrypted_list.remove their_id, secret
      send_connection_message their_id, :destroy
    else
      false
    end
  end

  def send_connection_message(their_id, type)
    them = User.find their_id
    qc = ConnectionQueue.new
    qc.user_id = their_id
    qc.message_type = type
    qc.message_body = String(self.id)
    qc.encrypt them.public_key
    qc.save
  end

  def whitelisted
    unless Whitelist.include? email
      errors.add :email, "is not on our list. Do you even know anybody here?"
    else
      self.name = Whitelist.name_for email
      self.gender = Whitelist.gender_for email
    end
  end

  def generate_keys
    secret = Digest::SHA2.base64digest DA_SALT + password
    pk = OpenSSL::PKey::RSA.new 2048
    cipher = OpenSSL::Cipher::AES256.new :CBC

    self.private_key = pk.to_pem cipher, secret
    self.public_key = pk.public_key.to_pem
    self.save
  end

  def create_encrypted_list
    secret = Digest::SHA2.base64digest DA_SALT + password
    blank_e_list = EncryptedList.encrypt_list [], secret

    self.build_encrypted_list({:matched => blank_e_list, :requests => blank_e_list, :pending => blank_e_list})
  end

  def force_create_encrypted_list(pword)
    secret = Digest::SHA2.base64digest DA_SALT + pword
    blank_e_list = EncryptedList.encrypt_list [], secret

    self.build_encrypted_list({:matched => blank_e_list, :requests => blank_e_list, :pending => blank_e_list})
  end

end
