class EncryptedList < ActiveRecord::Base
  belongs_to :user

  # Public: Adds list reading functionality. Should keep other
  # method_missing things in working. This is pretty shitty though.
  def method_missing(*args)
    method_name = String(args[0])
    if method_name.starts_with? "read_" and method_name.ends_with? "_list"
      list = method_name.sub("read_","").sub("_list","")
      to_decrypt = self.attributes[list]
      self.class.decrypt_list to_decrypt, args[1]
    else
      super *args
    end
  end

  def dumb(key)
    requests_list = read_requests_list key
    puts String(requests_list)
  end
  # Public: Add a new connection request to the encrypted list. 
  #
  # new_request - The user id of the request.
  # type        - Either 'mine' or 'theirs' depending on who issued it.
  # key         - The user's private key/password.
  #
  # Examples:
  #
  #   el = User.first.encrypted_list
  #   el.add_new_request 8, 'mine', 'my_password'
  #
  # Returns a string either 'added', 'matched', 'existed', or 'failed'.
  def add_new_request(new_request, type, key)
    new_request = String(new_request)

    pending_list  = read_pending_list key
    requests_list = read_requests_list key
    matched_list  = read_matched_list key

    retv = 'failed'
    if type == :mine
      if pending_list.include? new_request
        puts 'pending list included it'
        pending_list.delete new_request
        matched_list.append new_request
        retv = 'matched'
      elsif requests_list.exclude? new_request
        puts 'requests list excluded it'
        requests_list.append new_request
        retv = 'added'
      else
        retv = 'existed'
      end
    elsif type == :theirs
      if requests_list.include? new_request
        puts 'requests list included it'
        requests_list.delete new_request
        matched_list.append new_request
        retv = 'matched'
      elsif !pending_list.include? new_request
        puts 'pending list excluded it'
        pending_list.append new_request
        retv = 'added'
      else
        retv = 'existed'
      end
    end 

    self.pending = self.class.encrypt_list pending_list, key
    self.requests = self.class.encrypt_list requests_list, key
    self.matched = self.class.encrypt_list matched_list, key
    self.save
    retv
  end

  # Public: Remove a previously made request.
  # 
  # their_id - The user id of the person who was requested who now must be removed.
  # 
  # Returns nothing important..... yet.
  def remove(their_id, key)
    pending_list  = self.class.decrypt_list(self.pending, key)
    requests_list = self.class.decrypt_list(self.requests, key)
    matched_list  = self.class.decrypt_list(self.matched, key)

    pending_list.delete their_id
    requests_list.delete their_id
    matched_list.delete their_id

    self.pending = self.class.encrypt_list pending_list, key
    self.requests = self.class.encrypt_list requests_list, key
    self.matched = self.class.encrypt_list matched_list, key
    self.save
  end

  class << self
    # Private: Get a cipher object for encryption/decryption.
    #
    # type - A string either 'encryption' or 'decryption'.
    # key  - The user's private key/password.
    #
    # Returns a cipher object.
    def get_cipher(type, key)
      cipher = OpenSSL::Cipher::AES256.new :CBC
      if type == 'encryption'
        cipher.encrypt
      elsif type == 'decryption'
        cipher.decrypt
      end

      cipher.pkcs5_keyivgen key

      cipher
    end

    # Private: Decrypt a list.
    #
    # list - A string representing an encrypted list.
    # key  - Private key/password used to encrypt the list.
    #
    # Returns a list (Ruby Array).
    def decrypt_list(list, key)
      encrypted_list = Base64.decode64 list
      cipher = get_cipher 'decryption', key
      decrypted_list = cipher.update encrypted_list
      decrypted_list << cipher.final
      parsed_list = ActiveSupport::JSON::decode decrypted_list
    end

    # Private: Encrypt a list.
    #
    # list - A Ruby Array.
    # key  - Private key/password to encrypt with.
    #
    # Returns a string representing the encrypted list.
    def encrypt_list(list, key)
      cipher = get_cipher 'encryption', key
      encoded_list = ActiveSupport::JSON::encode list
      encrypted_list = cipher.update encoded_list
      encrypted_list << cipher.final
      encrypted_list = Base64.encode64 encrypted_list
    end
  end

end
