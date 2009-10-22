
require 'test_helper'
require 'net/imap'

#
# need an imap client to test this
#
class ProvXnTest < ActiveSupport::TestCase

  USERNAME = "btest"
  PASSWORD = "provxntest"
  EMPLOYEENUMBER = "0010"

  def test_find 
    
    usr = ProvXn.find(EMPLOYEENUMBER)
    
    assert_equal USERNAME, usr.username
    assert_equal EMPLOYEENUMBER, usr.employeenumber
    
  end
  
  def test_update
    
    usr = ProvXn.new
    
    usr.employeenumber = EMPLOYEENUMBER
    usr.password = PASSWORD
    
    puts usr.inspect

    usr.update
    
    puts usr.errors.inspect

    # test the password change by logging into IMAP
    assert_nothing_raised(Net::IMAP::NoResponseError) { 
      imap = Net::IMAP.new('imap.gmail.com', 993, true)
      imap.login("#{USERNAME}@nyit.edu", "#{PASSWORD}")    
    }
    
  end

end
