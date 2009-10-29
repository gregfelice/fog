
require 'test_helper'
require 'net/imap'

require 'provisioner_google'
require 'provisioner_mock'


#
# need an imap client to test this
#
class ProvisionerGoogleTest < ActiveSupport::TestCase

  def test_retrieve
    
    usr = ProvisionerMock.get_fog_gmail_student
    
    #puts usr.inspect

    #puts usr.username
    #puts usr.password
    #puts usr.employeenumber

    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    returned_usr = p.retrieve_user(usr.username)
    
    assert_not_nil returned_usr
    
    assert_equal(usr.username, returned_usr.username)

    assert_nil(returned_usr.employeenumber)
    assert_nil(returned_usr.password)

  end
  
  def test_update

    usr = ProvisionerMock.get_fog_gmail_student
    
    p = Provisioner::ProvisionerGoogle.new
    p.init
    
    returned_usr = p.retrieve_user(usr.username)
    returned_usr.password = usr.password

    p.update_user(returned_usr)
    
    # test the password change by logging into IMAP
    assert_nothing_raised(Net::IMAP::NoResponseError) { 
      imap = Net::IMAP.new('imap.gmail.com', 993, true)
      imap.login("#{usr.username}@nyit.edu", "#{usr.password}")    
    }
    
  end
  
end
