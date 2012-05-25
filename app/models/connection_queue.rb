class ConnectionQueue < ActiveRecord::Base
  validates_uniqueness_of :message_body, :scope => [:message_type, :user_id]

  MESSAGE_TYPE = [:create, :destroy]

  def decrypt(key, secret)
    privk = OpenSSL::PKey::RSA.new key, secret
    encrypted_message_body = Base64.decode64 self.message_body
    privk.private_decrypt encrypted_message_body
  end

  def encrypt(key)
    pubk = OpenSSL::PKey::RSA.new key
    encrypted_message_body = pubk.public_encrypt self.message_body
    self.message_body = Base64.encode64 encrypted_message_body
  end

end
