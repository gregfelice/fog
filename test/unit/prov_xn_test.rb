require 'test_helper'

#
# need an imap client to test this
#
class ProvXnTest < ActiveSupport::TestCase

  # Replace this with your real tests.

  test "the truth" do

    assert true

  end
  

  def test_provisioner_google

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr
    
    #usr.password = pwd = "passwd-#{(Time.now.usec).to_s}"

    usr.password = pwd = "testpassword"
    
    puts usr.password

    p.update_user(usr)
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr

  end

  def test_provisioner_iplanet
    
    p = Provisioner::ProvisionerIplanet.new
    p.init
 
    usr = p.retrieve_user("12371928679182347") # employeeid
    
    assert_provxn usr

    usr.password = pwd = "testpassword"
    
    # puts usr.password

    p.update_user(usr)
    
    usr = p.retrieve_user("29387198273123")
    
    assert_provxn usr

  end

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
  
  private 

  def assert_provxn(usr)

    assert_not_nil usr

    assert_not_nil usr.username
  
  end
  
end
