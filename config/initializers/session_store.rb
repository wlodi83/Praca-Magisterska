# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_praca_magisterska_session',
  :secret      => '24b396ceb7ea3188ac7e4764a89064dba0b8cc4abbe8e0a2b88424b8e29483ccd4f2d3167e134fbb7d6117d568f83a3154ef9bd84623a8eb943bda30ae87e527'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
