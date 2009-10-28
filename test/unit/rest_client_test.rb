
require 'test_helper'
require 'rest_client'
require 'util'
require 'net/imap'
require 'provisioner_interface'

require 'base64'
require 'ldap'

=begin
- authenticate - success
- authenticate - failure

=end
class RestClientTest < ActiveSupport::TestCase

  ##############################################################
  
  def test_retrieve
    resp = get('0012')
    puts resp
  end

  def test_retrieve_failed

  end

  def test_update
    usr = ProvisionerMock.get_fog_gmail_student
    resp = put(usr.employeenumber, get_update_xml(usr))
    validate_google(usr.username, usr.password)
  end

  def test_update_failed

  end
  
  ##############################################################

  private
  
  def get(employeenumber)
    return get_client.GET("/prov_xns/#{employeenumber}.xml")    
  end
  
  def put(employeenumber, xml)
    return get_client.PUT("/prov_xns/#{EMPLOYEENUMBER}.xml", xml)    
  end

  def get_client
    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/xml'})
    client.basic_auth('gregf', 'password')
    return client
  end

  def get_update_xml(prov_xn)
    xml = <<EOF
      <prov-xn>
        <employeenumber>#{prov_xn.employeenumber}</employeenumber>
        <password>#{prov_xn.password}</password>
      </prov-xn>
EOF
    return xml
  end

end
