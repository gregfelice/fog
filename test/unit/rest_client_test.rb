
require 'test_helper'
require 'rest_client'

#
# 
#
class ProvXnTest < ActiveSupport::TestCase

  def test_fog_retrieve
    
    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/atom+xml'})
    
    assert_not_nil client

    resp = client.GET("/prov_xns/0010.xml")    

    assert_not_nil resp

    puts resp
    
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
  
end



      
