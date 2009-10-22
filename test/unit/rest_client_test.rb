
require 'test_helper'
require 'rest_client'
require 'util'
require 'net/imap'

#
# 
#
class ProvXnTest < ActiveSupport::TestCase

  EMPLOYEENUMBER = "0010"
  USERNAME = "btest"
  PASSWORD = "kvetch"

  def test_fog_retrieve
    
    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/atom+xml'})
    
    resp = client.GET("/prov_xns/#{EMPLOYEENUMBER}.xml")    
    
    assert_not_nil resp
    
    # check to see if the correct values were actually returned
    
  end
  
  # PUT /prov_xns/1
  # PUT /prov_xns/1.xml
  def test_fog_update
    
    puts USERNAME
    puts PASSWORD

    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/atom+xml'})

    assert_not_nil client
    
    xml = <<EOF    
<prov-xn>
  <comment nil="true"/>
  <created-at nil="true" type="datetime"/>
  <employeenumber>#{EMPLOYEENUMBER}</employeenumber>
  <familyname nil="true"/>
  <givenname nil="true"/>
  <password>#{PASSWORD}</password>
  <suspended nil="true"/>
  <updated-at nil="true" type="datetime"/>
  <username nil="true"/>
</prov-xn>
EOF
    
    resp = client.PUT("/prov_xns/#{EMPLOYEENUMBER}.xml", xml)    

    # test the password change by logging into IMAP
    assert_nothing_raised(Net::IMAP::NoResponseError) { 
      imap = Net::IMAP.new('imap.gmail.com', 993, true)
      imap.login("#{USERNAME}@nyit.edu", "#{PASSWORD}")    
    }
    
  end
  
end


