
class ProvisionerMock

=begin

- student w/email in thor (fog-thor-student)

employeenumber 0011
username fog.thor.student password
userclass student
mailhost thor.nyit.edu
adadmindn na
iplanetdn uid=fog.thor.student, ou=people, o=nyit.edu, o=isp
familyname thor.student
givenname fog
suspended 0 
=end
  def self.get_fog_thor_student
    usr = ProvXn.new
    usr.employeenumber = '0011'
    usr.username = 'fog.thor.student'
    usr.password = 'password'
    usr.iplanetdn = 'uid=fog.thor.student, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
	usr.suspended = 0
    return usr
  end

=begin

. student w/email in mymailg (fog.gmail.student)

employeenumber 0012
username fog.gmail.student
password password
userclass student
mailhost mymailg.nyit.edu
adadmindn na
iplanetdn uid=fog.gmail.student, ou=people, o=nyit.edu, o=isp
familyname gmail.student
givenname fog
suspended 0
=end
  def self.get_fog_gmail_student
    usr = ProvXn.new
    usr.employeenumber = '0012'
    usr.username = 'fog.gmail.student'
    usr.password = 'kvetch'
    usr.iplanetdn = 'uid=fog.gmail.student, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
	usr.suspended = 0
    return usr
  end

=begin

. student w/email in thor (fog.thor.student)

employeenumber 0011
username fog.thor.student
password password
userclass student
mailhost thor.nyit.edu
adadmindn na
iplanetdn uid=fog.thor.student, ou=people, o=nyit.edu, o=isp
familyname thor.student
givenname fog
suspended 0 
=end
  def self.get_fog_thor_student_bad_password
    usr = ProvXn.new
    usr.employeenumber = '0011'
    usr.username = 'fog.thor.student'
    usr.password = '12hi3u12hiuc3ho1iud'
    usr.iplanetdn = 'uid=fog.thor.student, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
    usr.suspended = 0
	return usr
  end
  
=begin

. student w/email in thor (fog.thor.student)

employeenumber 0011
username fog.thor.student
password password
userclass student
mailhost thor.nyit.edu
adadmindn na
iplanetdn uid=fog.thor.student, ou=people, o=nyit.edu, o=isp
familyname thor.student
givenname fog
suspended 0 
=end
  def self.get_fog_thor_student_bad_employee_number
    usr = ProvXn.new
    usr.employeenumber = '001qwd1'
    usr.username = 'fog.thor.student'
    usr.password = 'password'
    usr.iplanetdn = 'uid=fog.thor.student, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
    usr.suspended = 0
	return usr
  end
  
=begin

. student w/email in thor (fog.thor.student)

employeenumber 0011
username fog.thor.student
password password
userclass student
mailhost thor.nyit.edu
adadmindn na
iplanetdn uid=fog.thor.student, ou=people, o=nyit.edu, o=isp
familyname thor.student
givenname fog
suspended 0 
=end
  def self.get_fog_thor_student_nonexistent
    usr = ProvXn.new
    usr.employeenumber = '0000'
    usr.username = 'fog.thor.student'
    usr.password = 'password'
    usr.iplanetdn = 'uid=fog.thor.student, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
    usr.suspended = 0
	return usr
  end
  
=begin

. staff w/email in owexht (fog.owexht.staff)

employeenumber 0013
username fog.owexht.staff
password password
userclass staff
mailhost owexht.nyit.edu
adadmindn CN=fog owexht staff,OU=Temporary_Accounts,OU=Users,OU=Admin_Unit,DC=admin,DC=nyit,DC=edu
iplanetdn uid=fog.owexht.staff, ou=people, o=nyit.edu, o=isp
familyname owexht.staff
givenname fog
suspended 0
=end
  def self.get_fog_owexht_staff
    usr = ProvXn.new
    usr.employeenumber = '0013'
    usr.username = 'fog.owexht.staff'
    usr.password = 'password'
    usr.iplanetdn = 'uid=fog.owexht.staff, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = 'CN=fog owexht staff,OU=Temporary_Accounts,OU=Users,OU=Admin_Unit,DC=admin,DC=nyit,DC=edu'
    usr.suspended = 0
	return usr
  end  

=begin

. staff w/email in thor (fog.thor.staff)

employeenumber 0014
username fog.thor.staff
password password
userclass staff
mailhost thor.nyit.edu
adadmindn @todo damien
iplanetdn uid=fog.thor.staff, ou=people, o=nyit.edu, o=isp
familyname thor.staff
givenname fog
suspended 0
=end
  def self.get_fog_thor_staff
    usr = ProvXn.new
    usr.employeenumber = '0014'
    usr.username = 'fog.thor.staff'
    usr.password = 'password'
    usr.iplanetdn = 'uid=fog.thor.staff, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
    usr.suspended = 0
	return usr
  end

=begin

. staff w/email in thor, suspended (fog.thor.staff.susp)

employeenumber 0015
username fog.thor.staff.susp
password password
userclass staff
mailhost thor.nyit.edu
adadmindn @todo damien
iplanetdn uid=fog.thor.staff.susp, ou=people, o=nyit.edu, o=isp
familyname thor.staff.susp
givenname fog
suspended 1
=end 
  def self.get_fog_thor_staff_susp
    usr = ProvXn.new
    usr.employeenumber = '0015'
    usr.username = 'fog.thor.staff.susp'
    usr.password = 'password'
    usr.suspended = '1'
    usr.iplanetdn = 'uid=fog.thor.staff.susp, ou=people, o=nyit.edu, o=isp'
    usr.adadmindn = nil
    usr.suspended = 1
	return usr
  end

end
