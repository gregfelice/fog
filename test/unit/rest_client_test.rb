
require 'test_helper'
require 'rest_client'
require 'util'
require 'net/imap'
require 'provisioner_interface'

require 'base64'
require 'ldap'

=begin

@todo 

tests
-----

- retrieve a user based on employeenumber - not found - check error codes
- retrieve a user based on employeenumber - success - check all fields

- retrieve suspended - prov_xn MUST return (business rules for changepw DO NOT handle suspended)

- update staff/faculty - check all fields
- update student - check all fields

- update a user - all fields - success - check all fields
- update a user - subset of fields - success - check all fields
- update a user - user not found by employeenumber - check error codes
- update a user - google provisioner fails - check error codes
- update a user - iplanet provisioner fails - check error codes
- update a user - ad provisioner fails - check error codes

- authenticate - success
- authenticate - failure

test profiles
-------------
- student w/email in thor (fog-thor-student)

employeenumber 0011
username fog-thor-student
password password
userclass student
mailhost thor.nyit.edu
adadmindn na
iplanetdn uid=fog-thor.student, ou=people, o=nyit.edu, o=isp
familyname thor-student
givenname fog
suspended 0 

- student w/email in mymailg (fog-gmail-student)

employeenumber 0012
username fog-gmail-student
password password
userclass student
mailhost mymailg.nyit.edu
adadmindn na
iplanetdn uid=fog-gmail.student, ou=people, o=nyit.edu, o=isp
familyname gmail-student
givenname fog
suspended 0


- staff w/email in owexht (fog-owexht-staff)

employeenumber 0013
username fog-owexht-staff
password password
userclass staff
mailhost owexht.nyit.edu
adadmindn cn=fog owexht-staff, ... @todo damien
iplanetdn uid=fog-owexht-staffjsmith30, ou=people, o=nyit.edu, o=isp
familyname owexht-staff
givenname fog
suspended 0

- staff w/email in thor (fog-thor-staff)

employeenumber 0014
username fog-thor-staff
password password
userclass staff
mailhost thor.nyit.edu
adadmindn @todo damien
iplanetdn uid=fog-thor-staff, ou=people, o=nyit.edu, o=isp
familyname thor-staff
givenname fog
suspended 0

- staff w/email in thor, suspended (fog-thor-staff-susp)

employeenumber 0015
username fog-thor-staff-susp
password password
userclass staff
mailhost thor.nyit.edu
adadmindn @todo damien
iplanetdn uid=fog-thor-staff-susp, ou=people, o=nyit.edu, o=isp
familyname thor-staff-susp
givenname fog
suspended 1


=end
class ProvXnTest < ActiveSupport::TestCase

  EMPLOYEENUMBER = "0010"
  USERNAME = "btest"
  PASSWORD = "kvetch"
  
  def test_retrieve_fog_thor_student_bad_password
  end
  
  def test_retrieve_fog_thor_student_bad_employee_number
  end
  
  def test_retrieve_fog_thor_student_nonexistent
  end
  
  def test_retrieve_fog_owexht_student
  end
  
  def test_retrieve_fog_owexht_staff
  end
  
  def test_retrieve_fog_thor_staff
  end
  
  def test_retrieve_fog_thor_staff_susp
  end

  def test_update_fog_thor_student_bad_password
  end
  
  def test_update_fog_thor_student_bad_employee_number
  end
  
  def test_update_fog_thor_student_nonexistent
  end
 
  def test_update_fog_owexht_student
  end
  
  def test_update_fog_owexht_staff
  end
  
  def test_update_fog_thor_staff
  end
  
  def test_update_fog_thor_staff_susp
  end

  ##############################################################
  
  def test_retrieve_fog_gmail_student
    resp = get('0012')
    puts resp
  end

  def test_update_fog_gmail_student
    usr = ProvXn.new('0012', 'fog.gmail.student', 'password')
    resp = put(usr.employeenumber, get_update_xml(usr))
    validate_google(usr.username, usr.password)
  end

  def test_retrieve_fog_thor_student
    resp = get('0011')
    puts resp
  end

  def test_update_fog_thor_student
    usr = ProvXn.new('0011', 'fog.thor.student', 'password')
    resp = put(usr.employeenumber, get_update_xml(usr))
    validate_google(usr.username, usr.password)
  end
  
  ##############################################################

  private
  
  def get(employeenumber)
    return get_client.GET("/prov_xns/#{employeenumber}.xml")    
  end
  
  def put(employeenumber, xml)
    return get_client.PUT("/prov_xns/#{EMPLOYEENUMBER}.xml", xml)    
  end
  
  def validate_iplanet(dn, password)
    @ldapconn = LDAP::Conn.new("ldap1.nyit.edu", 389)
    @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
    @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
    @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
    @ldapconn.bind(dn, password)
  end
  
  def validate_adadmin(dn, password)
    @ldapconn = LDAP::SSLConn.new("owdc2-srv.nyit.edu", 636)
    @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
    @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
    @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
    @ldapconn.set_option( LDAP::LDAP_OPT_REFERRALS, 0 )
    @ldapconn.bind(dn, password)
  end

  def validate_google(username, password)
    imap = Net::IMAP.new('imap.gmail.com', 993, true)
    imap.login("#{username}@nyit.edu", password)
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
  
  # test with basic http authentication.
  def test_http_basic_ath
    
    #puts "000000000000000000000000000000000000000000000000000000000000000000000000000000"
    #puts Base64.encode64('gregf:password')
    #puts "Z3JlZ2Y6cGFzc3dvcmQ="
    #puts "000000000000000000000000000000000000000000000000000000000000000000000000000000"
    
    headers = {'content-type' => 'application/xml'}

    client = RestClient.new('automattest.nyit.edu', 80, headers)
    client.basic_auth("gregf", "password")
    
    resp = client.GET("/prov_xns/#{EMPLOYEENUMBER}.xml")    
    
    assert_not_nil resp
    
    puts resp
  end

  def test_fog_retrieve
    
    client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/xml'})
    
    resp = client.GET("/prov_xns/#{EMPLOYEENUMBER}.xml")    
    
    assert_not_nil resp
    
    # check to see if the correct values were actually returned
    # puts resp
  end

end
