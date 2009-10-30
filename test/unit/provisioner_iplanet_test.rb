
require 'test_helper'
require 'provisioner_iplanet'
require 'provisioner_exception'

#
# need an imap client to test this
#
class ProvisionerIplanetTest < ActiveSupport::TestCase
  
  def test_retrieve_invalid_user
    
    p = Provisioner::ProvisionerIplanet.new    
    
    assert_not_nil p
    p.init

    assert_raise(ActiveRecord::RecordNotFound){
      usr = p.retrieve_user("invalidnumber") # employeeid
      }
    
  end


  def test_retrieve_too_many_users_per_employeenumber
    
    p = Provisioner::ProvisionerIplanet.new    
    
    assert_not_nil p
    p.init
    
    assert_raise(Provisioner::ProvisionerException) {
      usr = p.retrieve_user("0314981") # employeeid
    }
    
  end



  def test_retrieve_valid_user
    
    p = Provisioner::ProvisionerIplanet.new    
    
    assert_not_nil p
    
    p.init
    
    usr = p.retrieve_user("0012") # employeeid

    #puts usr
    
    assert_provxn usr

  end





  def test_password_change
    
    p = Provisioner::ProvisionerIplanet.new    
    
    assert_not_nil p
    
    p.init
    
    testuser = Hash.new
    testuser['employeenumber'] = "0011"
    testuser['password'] = "kvetch2"
    
    usr = p.update_user_attributes(testuser) # employeeid

  end






  
  private 
  
  def assert_provxn(usr)
    
    assert_not_nil usr

    assert_not_nil usr.username
  
  end
  
end
