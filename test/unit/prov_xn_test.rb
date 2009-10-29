
require 'test_helper'
require 'net/imap'

=begin
=end
class ProvXnTest < ActiveSupport::TestCase

  def test_retrieve_fog_thor_student_bad_employee_number
    mockusr = ProvisionerMock.get_fog_thor_student_bad_employee_number
    assert_raise(ActiveRecord::RecordNotFound) {
      usr = ProvXn.find(mockusr.employeenumber)
    }
  end
  
  def test_retrieve_fog_thor_student_nonexistent
    mockusr = ProvisionerMock.get_fog_thor_student_nonexistent
    assert_raise(ActiveRecord::RecordNotFound) {
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
    #puts mockusr.iplanetdn.inspect
    #puts
    #puts usr.iplanetdn.inspect
    #puts
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
  def test_update_fog_password_nil
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    x = usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => nil } )
    #puts "errors: [#{usr.errors.full_messages}]"
    assert_equal usr.errors.length, 1
  end

  # validaiton should prevent badly formed passwords
  # check for bad chars, too long, too short
  def test_update_fog_password_too_short
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    x = usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => "xx" } )
    #puts "errors: [#{usr.errors.full_messages}]"
    assert_equal usr.errors.length, 1
  end

  # validaiton should prevent badly formed passwords
  # check for bad chars, too long, too short
  def test_update_fog_password_too_long
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    x = usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => "xxxxxxxxxxxxxxxxxxxxxxxx" } ) 
    #puts "errors: [#{usr.errors.full_messages}]"
    assert_equal usr.errors.length, 1
  end

  # validaiton should prevent badly formed passwords
  # check for bad chars, too long, too short
  def test_update_fog_password_bad_chars
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    x = usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => "//??//??" } ) 
    #puts "errors: [#{usr.errors.full_messages}]"
    assert_equal usr.errors.length, 1
  end
  
  def test_update_fog_thor_student_bad_employee_number
    mockusr = ProvisionerMock.get_fog_thor_student
    usr = ProvXn.find(mockusr.employeenumber)
    usr.employeenumber = "1298390182091823BAD"
    # update the password
    assert_raise(ActiveRecord::RecordNotFound) {
      usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    }
  end
  
  def test_update_fog_owexht_student
    mockusr = ProvisionerMock.get_fog_owexht_student
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpass')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_owexht_staff
    mockusr = ProvisionerMock.get_fog_owexht_staff
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpass')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_thor_staff
    mockusr = ProvisionerMock.get_fog_thor_staff
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpass')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end
  
  def test_update_fog_thor_staff_susp
    mockusr = ProvisionerMock.get_fog_thor_staff_susp
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpass')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end

  def test_update_fog_gmail_student
    mockusr = ProvisionerMock.get_fog_gmail_student
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    assert_equal usr.errors.length, 0, "user errors: [#{usr.errors.full_messages}]"
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpass')
    # change back to old password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => mockusr.password } )
  end

  def test_update_fog_thor_student
    mockusr = ProvisionerMock.get_fog_thor_student
    usr = ProvXn.find(mockusr.employeenumber)
    # update the password
    usr.update_attributes( { 'employeenumber' => usr.employeenumber, 'password' => 'newpass' } )
    # validate via mailhost in question
    validate_iplanet(usr.iplanetdn, 'newpass')
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

    assert_equal usr.errors.length, 0 # no errors on the object

    assert_nil usr.password # for security purposes, retrieve methods will never return a password string 

    assert_equal usr.employeenumber, mockusr.employeenumber
    assert_equal usr.username, mockusr.username
    assert_equal usr.iplanetdn, mockusr.iplanetdn
    assert_equal usr.adadmindn, mockusr.adadmindn
    assert_equal usr.suspended, mockusr.suspended
  end

end
