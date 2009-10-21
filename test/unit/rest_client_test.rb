
require 'test_helper'
require 'rest_client'
require 'util'

#
# 
#
class ProvXnTest < ActiveSupport::TestCase

  def test_fog_retrieve
    
    client = RestClient.new('automattest.nyit.edu', 443, {'content-type' => 'application/x-www-form-urlencoded'})

    data = { 'username' => 'btest', 'password' => 'password', 'service' => 'prov_xn' }

    resp = client.POST("/accounts/login", Util.hash_to_querystring(data))
    
    puts resp.inspect
    
    # should contain an auth hash that has an expiration timestamp.
    
  end

  # PUT /prov_xns/1
  # PUT /prov_xns/1.xml
  def test_fog_update
    
    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/atom+xml'})

    assert_not_nil client
    
    employeenumber = "0010"
    password = "roobyrat"
    
    xml = <<EOF    
<prov-xn>
  <comment nil="true"/>
  <created-at nil="true" type="datetime"/>
  <employeenumber>#{employeenumber}</employeenumber>
  <familyname nil="true"/>
  <givenname nil="true"/>
  <password>#{password}</password>
  <suspended nil="true"/>
  <updated-at nil="true" type="datetime"/>
  <username nil="true"/>
</prov-xn>
EOF
    
    resp = client.PUT("/prov_xns/007.xml", xml)    
    puts resp

  end

  def test_ath
    
    client = RestClient.new('automattest.nyit.edu', 443, {'content-type' => 'application/x-www-form-urlencoded'})

    resp = client.GET("/sessions/new.xml")

    data = { 'session_name' => 'test-session', 'session_password' => 'password' }

    resp = client.POST("/sessions/create.xml", Util.hash_to_querystring(data))
    
    puts resp

  end
  
end



      
