
require 'ldap'

require 'provisioner_interface'
require 'provisioner_exception'

=begin

=end
module Provisioner

  class ProvisionerADAdmin < ProvisionerInterface

    @ldapconn = nil
    
    def init	
    	  
      @ldapconn = LDAP::SSLConn.new("owdc2-srv.nyit.edu", 636)
      @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
      @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
      @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
      @ldapconn.set_option( LDAP::LDAP_OPT_REFERRALS, 0 )
      @ldapconn.bind("CN=Portal Reset User,OU=System Accounts,OU=Users,OU=OIT_Unit,DC=admin,DC=nyit,DC=edu","JuZ3mE4n0w")
      
    end
    

    def retrieve_user(employeenumber)
      
      raise ArgumentError, "employeenumber blank", caller if employeenumber.empty? 
	
      base = "dc=admin,dc=nyit,dc=edu"
      scope = LDAP::LDAP_SCOPE_SUBTREE
      
      filter = "(employeeid=#{employeenumber})"
      entries = @ldapconn.search2(base, scope, filter) 
      
      if entries.length == 0
        raise ActiveRecord::RecordNotFound
      elsif entries.empty?
       raise ActiveRecord::RecordNotFound
      elsif entries.length > 1
        raise ProvisionerException.new(nil, "More than one user returned."), "More than one user returned."
      end

	  
	  retrievedadadminuser = entries.first
      
      xn = ProvXn.new      
      xn.username = retrievedadadminuser['sAMAccountName'].to_s
      xn.employeenumber = retrievedadadminuser['employeeID'].to_s
      xn.familyname = retrievedadadminuser['sn'].to_s
      xn.givenname = retrievedadadminuser['givenName'].to_s
	  xn.adadmindn = retrievedadadminuser['distinguishedName'].to_s
      !(retrievedadadminuser['userAccountControl'].to_s == "512") ? xn.suspended = 1 : xn.suspended = 0
      
      return xn
      
    end
    
    def create_user(user)
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
      #
      
    end
    
    #
    # preconditions: provxn has employeeid and password, and user is not disabled
    #
    # postconditions: user's password is updated in iplanet
    #
    def update_user_attributes(attributes)
      
      raise ArgumentError, "Password is empty.", caller if attributes['password'] == nil 
      raise ArgumentError, "Employeenumber is empty.", caller if attributes['employeenumber'] == nil 

      retrievedadadminuser = retrieve_user(attributes['employeenumber'])

		
	  if !(retrievedadadminuser['suspended'] == 0)
        raise Provisioner::SuspendedUserException.new(nil, "User is suspended."), "User is suspended."
      end

      #Create Unicode password
      def self.ct2uni(cleartextpwd)
        quotepwd = '"' + cleartextpwd + '"'
        unicodepwd = Iconv.iconv('UTF-16LE', 'UTF-8', quotepwd).first
        return unicodepwd
      end
      
      unicodepassword = ct2uni(attributes['password'])
      
      modifieduserattrs = Hash.new
      modifieduserattrs['unicodePwd'] = [unicodepassword]
    
      @ldapconn.modify(retrievedadadminuser['adadmindn'].to_s, modifieduserattrs)
    
    end

	
	
	 def update_user(provxn)
      
      raise ArgumentError, "Password is empty.", caller if provxn.password == nil 
      raise ArgumentError, "Employeenumber is empty.", caller if provxn.employeenumber == nil 
      
      attributes = { "employeenumber" => provxn.employeenumber, "password" => provxn.password}
      
      update_user_attributes(attributes)
      
    end
	
	
	
	
	
	
	
	
	
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
    end
    
  end
  
end # module
