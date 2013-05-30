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

