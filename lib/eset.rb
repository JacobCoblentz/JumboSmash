# convenience class for going between encrypted strings and sets
class ESet
  attr :string, :set
  attr_accessor :key

  def initialize value, key
    if value.kind_of? String
      @string = value
    elsif value.kind_of? Set or value.kind_of? Array
      @set = Set.new value
    end
    @key = key
  end

  def string
    @string ||= encrypt
  end

  def string=(new_string)
    @set = nil
    @string = new_string
  end

  def set
    @set ||= decrypt
    # always nil out @string in case @set gets modified
    @string = nil
    @set
  end

  def set=(new_set)
    @string = nil
    @set = Set.new new_set
  end

  # Returns the encrypted and encoded form of this set
  def encrypt
    cipher = get_cipher 'encryption'
    encoded_set = ActiveSupport::JSON::encode @set
    encrypted_set = cipher.update encoded_set
    encrypted_set << cipher.final
    Base64.encode64 encrypted_set
  end

  def decrypt
    encrypted_string = Base64.decode64 @string
    cipher = get_cipher 'decryption'
    decrypted_string = cipher.update encrypted_string
    decrypted_string << cipher.final
    parsed_string = ActiveSupport::JSON::decode decrypted_string
    Set.new parsed_string
  end

  def get_cipher(type)
    raise "No key for encryption" unless @key
    cipher = OpenSSL::Cipher::AES256.new :CBC
    if type == 'encryption'
      cipher.encrypt
    elsif type == 'decryption'
      cipher.decrypt
    end
    cipher.pkcs5_keyivgen @key
    cipher
  end
end


# for saving ESets to the DB
class ESetCoder
  def load(encrypted_string)
    ESet.new encrypted_string, nil
  end
  
  def dump(eset)
    eset.string
  end
end