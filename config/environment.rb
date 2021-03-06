# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "haml"
  # config.gem "RedCloth"
  # config.gem "memcache-client", :lib => "memcache"
  config.gem "mocha"
  config.gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => "http://gems.github.com"

  if RAILS_ENV == 'test'
    config.gem 'assert2'
    config.gem 'iridesco-time-warp', :lib => 'time_warp', :source => "http://gems.github.com"
  end
  
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  session_secret =
    if RAILS_ENV == 'production'
      session_config_file = File.expand_path("#{RAILS_ROOT}/config/session.secret")
      unless File.exists?(session_config_file)
        fail "No config/session.secret found. Please create one with 'rake --silent secret > /path/to/app/shared/config/session.secret'"
      end
      File.open(session_config_file).read.strip
    else
      #the secret for development & test
      'a21d1958f9be9c101816d0b297eac9b5b43a8d5a25c14dafe0000247ade18fa1ef6f97459815743f3b43ef2bf7558d86380ef1e1a5434b2ffff48e96568341a5'
    end

  config.action_controller.session = {
    :session_key => "_photo_session#{'test' if RAILS_ENV == 'test'}",
    :secret      => session_secret
  }

  # BH - To run on Dreamhost, under Passenger, mod_rewrite is not on by default. This makes
  # rewriting to an alternative cache directory location impossible. At least this is what
  # I have gathered in my discussions with Dreamhost.
  # config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
end

ExceptionNotifier.sender_address       = Pharm::Config.options['exception_sender']
ExceptionNotifier.exception_recipients = Pharm::Config.options['exception_recipients']

ENV["RAILS_ENV"] ||= "test"
