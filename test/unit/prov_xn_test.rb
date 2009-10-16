require 'test_helper'

class ProvXnTest < ActiveSupport::TestCase

  # Replace this with your real tests.

  test "the truth" do

    assert true

  end
  
  test "provisioner google" do

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr
    
    usr.password = pwd = "passwd-#{(Time.now.usec).to_s}"
    
    p.update_user(usr)
    
    usr = p.retrieve_user("btest")
    
    assert_provxn usr

  end
  
  test "provxn retrieval" do
    
    usr = ProvXn.find("btest")
    
    assert_provxn usr
    
  end

  test "provxn update" do
    
    usr = ProvXn.new

    assert_not_nil usr
        
    usr.username = "btest"
    usr.password = "password"
    usr.familyname = "hammerschitdt"
    usr.givenname = "oomler"
    
    usr.update
    
    assert_provxn usr
    
    usr = ProvXn.find("btest")

    assert_provxn usr
    
  end
  
  private 

  def assert_provxn(usr)

    assert_not_nil usr

    assert_not_nil usr.username
    assert_not_nil usr.familyname
    assert_not_nil usr.givenname
  
  end
  
end
