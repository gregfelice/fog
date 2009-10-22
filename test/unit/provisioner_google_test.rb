
require 'test_helper'
require 'net/imap'

require 'provisioner_google'

#
# need an imap client to test this
#
class ProvisionerGoogleTest < ActiveSupport::TestCase

  USERNAME = "btest"
  PASSWORD = "provgoogtest"
  
  def test_retrieve

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    usr = p.retrieve_user(USERNAME)
    
    assert_equal (USERNAME, usr.username)

  end
  
  def test_update

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    usr = p.retrieve_user(USERNAME)
    usr.password = PASSWORD

    p.update_user(usr)
    
    # test the password change by logging into IMAP
    assert_nothing_raised(Net::IMAP::NoResponseError) { 
      imap = Net::IMAP.new('imap.gmail.com', 993, true)
      imap.login("#{USERNAME}@nyit.edu", "#{PASSWORD}")    
    }
    
  end
  
end
