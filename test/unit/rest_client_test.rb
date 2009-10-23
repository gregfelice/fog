
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
    
    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/xml'})
    
    resp = client.GET("/prov_xns/#{EMPLOYEENUMBER}.xml")    
    
    assert_not_nil resp
    
    # check to see if the correct values were actually returned
    
  end
  
  # PUT /prov_xns/1
  # PUT /prov_xns/1.xml
  def test_fog_update
    
    #puts USERNAME
    #puts PASSWORD

    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/xml'})

    assert_not_nil client
    
    xml = <<EOF
<prov-xn>
  <employeenumber>#{EMPLOYEENUMBER}</employeenumber>
  <password>#{PASSWORD}</password>
</prov-xn>
EOF

    resp = client.PUT("/prov_xns/#{EMPLOYEENUMBER}.xml", xml)    
    
    # test the password change by logging into IMAP
    assert_nothing_raised(Net::IMAP::NoResponseError) { 
      #imap = Net::IMAP.new('imap.gmail.com', 993, true)
      #imap.login("#{USERNAME}@nyit.edu", "#{PASSWORD}")    
    }
    
  end
end


# PUT /accounts/1
# PUT /accounts/1.xml
=begin
  def test_creek_update
    
    #puts USERNAME
    #puts PASSWORD
    
    #client = RestClient.new('automattest.nyit.edu', 5000, {'content-type' => 'application/x-www-form-urlencoded'})

    client = RestClient.new('automattest.nyit.edu', 5000, {'content-type' => 'application/xml'}) # as opposed to application/atom+xml (google)
    
    assert_not_nil client
    
    xml = <<EOF
<account>
  <username>testusername</username>
</account>
EOF
    
    resp = client.PUT("/accounts/1.xml", xml)    
    
  end
=end
 


=begin

accounts:

  <created-at nil="true" type="datetime"/>
  <updated-at nil="true" type="datetime"/>

    xml = <<EOF
<prov-xn>
<adadmindn nil="true"/>
<comment nil="true"/>
<created-at nil="true" type="datetime"/>
<employeenumber>#{EMPLOYEENUMBER}</employeenumber>
<familyname nil="true"/>
<givenname nil="true"/>
<iplanetdn nil="true"/>
<mailhost nil="true"/>
<password nil="true"/>
<suspended nil="true"/>
<updated-at nil="true" type="datetime"/>
<userclass nil="true"/>
<username nil="true"/>
</prov-xn>
EOF


=end
