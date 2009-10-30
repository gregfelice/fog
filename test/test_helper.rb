ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def validate_iplanet(dn, password)
    raise ArgumentError, "dn is nil", caller if dn == nil
    raise ArgumentError, "password is nil", caller if password == nil
    @ldapconn = LDAP::Conn.new("ldap1.nyit.edu", 389)
    @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
    @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
    @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
    @ldapconn.bind(dn, password)
  end
  
  def validate_adadmin(dn, password)
    @ldapconn = LDAP::SSLConn.new("owdc2-srv.nyit.edu", 636)
    @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
    @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
    @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
    @ldapconn.set_option( LDAP::LDAP_OPT_REFERRALS, 0 )
    @ldapconn.bind(dn, password)
  end

  def validate_google(username, password)
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login("#{username}@nyit.edu", password)
  end

end
