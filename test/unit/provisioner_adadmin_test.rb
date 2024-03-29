require 'ldap'
require 'test_helper'
require 'provisioner_iplanet'
require 'provisioner_google'
require 'provisioner_adadmin'


#
# need an imap client to test this
#
class ProvXnTest < ActiveSupport::TestCase
  
  def test_retrieve_invalid_user
    
    p = Provisioner::ProvisionerADAdmin.new    
    
    assert_not_nil p
    p.init

    assert_raise(ActiveRecord::RecordNotFound){
      usr = p.retrieve_user("invalidnumber") # employeeid
    }
    
  end

=begin
  def test_retrieve_too_many_users_per_employeenumber
    
    p = Provisioner::ProvisionerIplanet.new    
    
    assert_not_nil p
    p.init

    assert_raise(Provisioner::ProvisionerException){
      usr = p.retrieve_user("0314981") # employeeid
      }
    
  end
=end


  def test_retrieve_valid_user
    
    p = Provisioner::ProvisionerADAdmin.new    
    
    assert_not_nil p
    
    p.init
    
    usr = p.retrieve_user("0010") # employeeid
    
    assert_provxn usr

  end




  def test_password_change
    
    p = Provisioner::ProvisionerADAdmin.new    
    
    assert_not_nil p
    
    p.init
    
    testuser = ProvXn.new
    testuser.employeenumber = "0010"
    testuser.password = "boing"
    
    usr = p.update_user(testuser) # employeeid

  end





  
private 
  
  def assert_provxn(usr)
    
    assert_not_nil usr

    assert_not_nil usr.username
  
  end
  
end
