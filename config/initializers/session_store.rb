# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fog_session',
  :secret      => 'ba30b67256d98c2ce19a0e38f52c12654b2f7d211a10c0f856c44cc07bcdafb05fbf16a6e3d97d4bb688b97a19bced0104b43c6f63b51e63af4fd2b08ea6d605'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
