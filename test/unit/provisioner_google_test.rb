require 'test_helper'
require 'net/imap'
require 'provisioner_google'
require 'provisioner_mock'

class ProvisionerGoogleTest < ActiveSupport::TestCase

  def test_retrieve
    usr = ProvisionerMock.get_fog_gmail_student
    p = Provisioner::ProvisionerGoogle.new
    p.init
    returned_usr = p.retrieve_user(usr.username)
    assert_not_nil returned_usr
    assert_equal(usr.username, returned_usr.username)
    assert_nil(returned_usr.employeenumber)
    assert_nil(returned_usr.password)
  end

  def test_retrieve_failed
    usr = ProvisionerMock.get_fog_gmail_student
    p = Provisioner::ProvisionerGoogle.new
    p.init
    assert_raise(ActiveRecord::RecordNotFound) {
      returned_usr = p.retrieve_user("BADUSERNAME")
    }
  end
  
  def test_update
    usr = ProvisionerMock.get_fog_gmail_student
    p = Provisioner::ProvisionerGoogle.new
    p.init
    returned_usr = p.retrieve_user(usr.username)
    returned_usr.password = "newpass"
    p.update_user(returned_usr)
    assert_nothing_raised(Net::IMAP::NoResponseError) { 
      imap = Net::IMAP.new('imap.gmail.com', 993, true)
      imap.login("#{usr.username}@nyit.edu", "newpass")    
    }
  end
end

