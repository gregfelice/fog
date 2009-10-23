
require 'ldap'

require 'provisioner_interface'
require 'provisioner_exception'
require 'object_not_found_exception'

=begin

=end
module Provisioner

  class ProvisionerIplanet < ProvisionerInterface

    @ldapconn = nil
    
    def init	
    	  
      @ldapconn = LDAP::Conn.new("ldap1.nyit.edu", 389)
      @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
      @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
      @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
      @ldapconn.bind("uid=portal.reset.user,ou=ServiceAccounts,o=nyit.edu,o=isp","JuZ3mE4n0w")
      
    end

    def retrieve_ldap_attributes(employeenumber)
  
      base = "ou=people, o=nyit.edu, o=isp"
      scope = LDAP::LDAP_SCOPE_SUBTREE

      filter = "(employeenumber=#{employeenumber})"
      entries = @ldapconn.search2(base, scope, filter) 

      if entries.length == 0
       raise ObjectNotFoundException.new(nil, "No users returned."), "No users returned."
      elsif entries.empty?
       raise ObjectNotFoundException.new(nil, "No users returned."), "No users returned."
      elsif entries.length > 1
        raise ProvisionerException.new(nil, "More than one user returned."), "More than one user returned."
      end

      retrievediplanetuser = entries.first
  
      return retrievediplanetuser
  
    end
    
    private :retrieve_ldap_attributes
    
    def retrieve_user(employeenumber)
      
      raise ArgumentError, "employeenumber blank", caller if employeenumber.empty? 
	
      retrievediplanetuser = retrieve_ldap_attributes(employeenumber)

      xn = ProvXn.new      
      xn.username = retrievediplanetuser['uid'].to_s
      xn.employeenumber = retrievediplanetuser['employeeNumber'].to_s
      xn.familyname = retrievediplanetuser['sn'].to_s
      xn.givenname = retrievediplanetuser['givenName'].to_s
      xn.userclass = retrievediplanetuser['userClass'].to_s
      xn.mailhost = retrievediplanetuser['mailHost'].to_s
      # @todo add more attributes here, if any
      # @todo add more attributes here, if any
      # @todo add more attributes here, if any
      
      (retrievediplanetuser['inetUserStatus'].to_s == "inactive" || retrievediplanetuser['userclass'].to_s == "separated") ? xn.suspended = 1 : xn.suspended = 0
      
      return xn
      
    end
    
    def create_user(user)
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
      #
    end
    
    def update_user_attributes(attributes)
      
      puts "provisioner_iplanet.update user attributes: #{attributes.inspect}"

      retrievediplanetuser = retrieve_ldap_attributes(attributes['employeenumber'])
      
      if (retrievediplanetuser['inetUserStatus'].to_s == "inactive" || retrievediplanetuser['userclass'].to_s == "separated")
        raise Provisioner::SuspendedUserException.new(nil, "User is suspended."), "User is suspended."
      end
      
      modifieduserattrs = Hash.new
      
      modifieduserattrs['userpassword'] = [ attributes['password'] ]
      # attributes now coming off of the hash argument instead of provxn object
      # @todo add more attributes here
      # @todo add more attributes here
      # @todo add more attributes here
      
      @ldapconn.modify(retrievediplanetuser['dn'].to_s, modifieduserattrs)
      
    end
    
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
    end
    
    
    #
    # preconditions: provxn has employeeid and password, and user is not disabled
    #
    # postconditions: user's password is updated in iplanet
    #
    def update_user(provxn)
      
      raise ArgumentError, "Password is empty.", caller if provxn.password == nil 
      raise ArgumentError, "Employeenumber is empty.", caller if provxn.employeenumber == nil 
      
      attributes = { "username" => provxn.username, "password" => provxn.password}
      
      update_user_attributes(attributes)
      
    end

  end
end # module


=begin
<prov-xn>
<adadmindn nil="true"/>
<comment nil="true"/>
<created-at nil="true" type="datetime"/>
<employeenumber nil="true"/>
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
=end
