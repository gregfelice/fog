
require 'test_helper'
require 'net/imap'
require 'object_not_found_exception' 

=begin

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

=end

class ProvXnTest < ActiveSupport::TestCase

  # should throw object not found exception
  def test_retrieve_fog_thor_student_bad_employee_number
    mockusr = ProvisionerMock.get_fog_thor_student_bad_employee_number
    assert_raise(Provisioner::ObjectNotFoundException) {
      usr = ProvXn.find(mockusr.employeenumber)
    }
  end
  
  def test_retrieve_fog_thor_student_nonexistent
    mockusr = ProvisionerMock.get_fog_thor_student_nonexistent
    assert_raise(Provisioner::ObjectNotFoundException) {
      usr = ProvXn.find(mockusr.employeenumber)
    }
  end
   
  def test_retrieve_fog_owexht_staff
    mockusr = ProvisionerMock.get_fog_owexht_staff
    usr = ProvXn.find(mockusr.employeenumber)
    assert_usr usr, mockusr
  end
  
  def test_retrieve_fog_thor_staff
    mockusr = ProvisionerMock.get_fog_thor_staff
    usr = ProvXn.find(mockusr.employeenumber)
    assert_usr usr, mockusr
  end
  
  def test_retrieve_fog_thor_staff_susp
    mockusr = ProvisionerMock.get_fog_thor_staff_susp
    usr = ProvXn.find(mockusr.employeenumber)
    assert_usr usr, mockusr
  end

  def test_retrieve_fog_gmail_student
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    #assert_usr usr, mockusr
	puts mockusr.iplanetdn.inspect
	puts
	puts usr.iplanetdn.inspect
	puts
	assert_equal usr.iplanetdn, mockusr.iplanetdn
	assert_usr usr,mockusr
  end

  def test_retrieve_fog_thor_student
    mockusr = ProvisionerMock.get_fog_thor_student
    usr = ProvXn.find(mockusr.employeenumber)
    assert_usr usr, mockusr
  end

  # validaiton should prevent badly formed passwords
  # check for bad chars, too long, too short
  def test_update_fog_thor_student_bad_password
    mockusr = ProvisionerMock.get_fog_thor_student_bad_password
    usr = ProvXn.find(mockusr.employeenumber)
    assert_raise(Provisioner::SOMEUNNAMEDEXCEPTIONRELATEDTOVALIDATION) {
      # update the password
      usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => '23(*@&#( 283d98223j' } )
    }
  end
  
  def test_update_fog_thor_student_bad_employee_number
    mockusr = ProvisionerMock.get_fog_thor_student_bad_employee_number
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_owexht_student
    mockusr = ProvisionerMock.get_fog_owexht_student
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_owexht_staff
    mockusr = ProvisionerMock.get_fog_owexht_staff
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_thor_staff
    mockusr = ProvisionerMock.get_fog_thor_staff
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_thor_staff_susp
    mockusr = ProvisionerMock.get_fog_thor_staff_susp
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end

  def test_update_fog_gmail_student
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end

  def test_update_fog_thor_student
    mockusr = ProvisionerMock.get_fog_thor_student
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpassword' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpassword')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end

  ##############################################################
 
  private

  # will only support updating the password for now.
  def test_update_attributes

    ProvisionerMock.get_
    
    attributes = { "username" => "testusername", "password" => "testpassword" }

    usr = ProvXn.new
    usr.update_attributes(attributes)

  end

  def assert_usr(usr, mockusr)
	assert_equal usr.employeenumber, mockusr.employeenumber
    assert_equal usr.username, mockusr.username
    assert_nil usr.password
    assert_equal usr.iplanetdn, mockusr.iplanetdn
	assert_equal usr.adadmindn, mockusr.adadmindn
    assert_equal usr.suspended, mockusr.suspended
  end

end
