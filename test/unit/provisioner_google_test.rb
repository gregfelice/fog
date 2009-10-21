
require 'test_helper'

require 'provisioner_google'

#
# need an imap client to test this
#
class ProvisionerGoogleTest < ActiveSupport::TestCase

  def test_retrieve

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr

  end
  
  def test_update

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr
    
    #usr.password = pwd = "passwd-#{(Time.now.usec).to_s}"

    usr.password = pwd = "testpassword"
    
    # puts usr.password

    p.update_user(usr)
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr

  end
    
  private 

  def assert_provxn(usr)

    assert_not_nil usr

    assert_not_nil usr.username
  
  end
  
end
