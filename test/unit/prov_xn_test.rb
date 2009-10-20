require 'ldap'
require 'test_helper'
require 'provisioner_iplanet'
require 'provisioner_google'


#
# need an imap client to test this
#
class ProvXnTest < ActiveSupport::TestCase

=begin 
  def test_provisioner_ad

  end

  test "provxn retrieval" do
    
    usr = ProvXn.find("btest")
    
    assert_provxn usr
    
  end

  test "provxn update" do
    
    usr = ProvXn.new

    assert_not_nil usr
        
    usr.username = "btest"
    usr.password = "testpassword"
    
    usr.update
    
    assert_provxn usr
    
    usr = ProvXn.find("btest")

    assert_provxn usr
    
  end
=end

  private 

  def assert_provxn(usr)

    assert_not_nil usr

    assert_not_nil usr.username
  
  end
  
end
