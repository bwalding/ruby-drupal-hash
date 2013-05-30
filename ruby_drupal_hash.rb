=begin
RubyDrupalHash.new.verify("password1234", "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMglI")
=end
class RubyDrupalHash
  DRUPAL_HASH_COUNT = 15
  DRUPAL_MIN_HASH_COUNT = 7
  DRUPAL_MAX_HASH_COUNT = 30
  DRUPAL_HASH_LENGTH = 55
  ITOA64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

  HASH = Digest::SHA2.new(512)

  def verify(password, hashed_password)
    setting = hashed_password[0..11]
    if setting[0] != '$' or setting[2] != '$'
      # Wrong hash format
      return false
    end
        
    count_log2 = ITOA64.index(setting[3])
    
    if count_log2 < DRUPAL_MIN_HASH_COUNT or count_log2 > DRUPAL_MAX_HASH_COUNT
      return false
    end

    salt = setting[4..4+7]
    
    if salt.length != 8
      return false
    end
    
    count = 2 ** count_log2
       
    pass_hash = HASH.digest(salt + password)

    1.upto(count) do |i|
      pass_hash = HASH.digest(pass_hash + password)
    end

    hash_length = pass_hash.length

    output = setting + _password_base64_encode(pass_hash, hash_length)
    binding.pry

    if output.length != 98
      return false
    end

    return output[0..(DRUPAL_HASH_LENGTH-1)] == hashed_password      
  end

  def _password_base64_encode(to_encode, count)
    output = ''
    i = 0
    while true
      value = (to_encode[i]).ord
          
      i += 1
          
      output = output + ITOA64[value & 0x3f]
      if i < count
        value |= (to_encode[i].ord) << 8
      end

      output = output + ITOA64[(value >> 6) & 0x3f]
  
      if i >= count
        break
      end

      i += 1
  
      if i < count
        value |= (to_encode[i].ord) << 16
      end
          
      output = output + ITOA64[(value >> 12) & 0x3f]
  
      if i >= count
        break
      end
      
      i += 1
      
      output = output + ITOA64[(value >> 18) & 0x3f]
          
      if i >= count
        break
      end
      
    end
    return output
  end
end

