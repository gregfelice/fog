
require 'test_helper'

#
# need an imap client to test this
#
class ProvXnTest < ActiveSupport::TestCase

  def test_find 
    
    usr = ProvXn.find("007")
    
    assert_not_nil usr.employeenumber
    assert_not_nil usr.username
    
  end
  
  def test_update
    
    usr = ProvXn.new
    
    assert_not_nil usr
        
    usr.username = "007"
    usr.password = "testpassword"
    
    usr.update
    
    # @todo implement an IMAP client to really test that the password change here worked for google.

  end

end
