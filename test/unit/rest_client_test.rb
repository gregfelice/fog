
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
    ProvisionerMock.get_fog_gmail_student
    resp = get(ProvisionerMock.get_fog_gmail_student.employeenumber)

    xml = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<prov-xn>
  <adadmindn nil="true"></adadmindn>
  <comment nil="true"></comment>
  <created-at nil="true" type="datetime"></created-at>
  <employeenumber>0012</employeenumber>
  <familyname>gmail student</familyname>
  <givenname>fog</givenname>
  <iplanetdn>uid=fog.gmail.student, ou=people, o=nyit.edu, o=isp</iplanetdn>
  <mailhost>mymailg.nyit.edu</mailhost>
  <password nil="true"></password>
  <suspended>0</suspended>
  <updated-at nil="true" type="datetime"></updated-at>
  <userclass>student</userclass>
  <username>fog.gmail.student</username>
</prov-xn>
EOF

    #puts "[#{xml}]"
    #puts "[#{resp}]"

    assert xml.eql?(resp.body.to_s)
  end

  def test_retrieve_failed
    bad_employeenumber = "191231233"
    resp = get(bad_employeenumber)
    assert_not_nil (resp.to_s =~ /HTTPNotFound/)
  end

  def test_update
    usr = ProvisionerMock.get_fog_gmail_student
    resp = put(usr.employeenumber, get_update_xml(usr))
    assert_not_nil (resp.to_s =~ /HTTPOK/)
    #puts "usr: #{usr.inspect}"
    validate_google(usr.username, usr.password)
  end

  def test_update_failed_not_found
    bad_employeenumber = "191231233"
    usr = ProvisionerMock.get_fog_gmail_student
    resp = put(bad_employeenumber, get_update_xml(usr))
    puts "resp: [#{resp}]"
    puts "resp: [#{resp.body}]"
    assert_not_nil (resp.to_s =~ /HTTPNotFound/)
  end

  def test_update_failed_bad_password
    
    error = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error>Password must contain at least two numeric characters.</error>
</errors>
EOF
    usr = ProvisionerMock.get_fog_gmail_student
    usr.password = "abcdef"
    resp = put(usr.employeenumber, get_update_xml(usr))
    puts "resp: [#{resp}]"
    puts "resp: [#{resp.body}]"
    #assert_not_nil (resp.to_s =~ /HTTPNotFound/)
    assert_equal resp.body, error
  end
  
  ##############################################################

  private
  
  def get(employeenumber)
    return get_client.GET("/prov_xns/#{employeenumber}.xml")    
  end
  
  def put(employeenumber, xml)
    return get_client.PUT("/prov_xns/#{employeenumber}.xml", xml)    
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
