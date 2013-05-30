If you ever have the misfortune of having a Drupal site that you want to migrate 
to Rails (for example), then you will discover that Drupal has a custom password
hashing algorithm.

The algorithm is SHA-512 with stretching, but does not use PBKDF2 to encode the
parameters to the algorithm.

This class offers this capability in native Ruby.

It was modelled off the Django implementation.


Usage:

    hasher = RubyDrupalHash.new
    password = "password1234"
    hash = "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMglI"
    if hasher.verify(password, hash)
      puts "Password matches"
    else
      puts "Password does not match"
    end



# OmniAuth Identity

To use this with OmniAuth Identity, override the authenticate method
and check for Drupal hashed passwords.

Put this in your ActiveRecord Identity class and it will confirm the Drupal
hash and then rehash the password using the Identity configuration (bcrypt)

    alias_method :authenticate_base, :authenticate
    def authenticate(password)
      # Handle Drupal passwords
      if self.password_digest[0..2] == '$S$'
        if OmniAuth::DrupalPasswordHasher.new.verify(password, self.password_digest)
          self.password = password
          self.password_confirmation = password
          self.save!
        end
      end
      return authenticate_base(password)
    end