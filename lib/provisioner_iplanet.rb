
require 'ldap'

require 'provisioner_interface'
require 'provisioner_exception'
require 'object_not_found_exception'

=begin

=end
module Provisioner

  class ProvisionerIplanet < ProvisionerInterface

    @HOST = "ldap1.nyit.edu"
    @PORT = LDAP::LDAP_PORT
    @SSLPORT = LDAP::LDAPS_PORT
    
    @binduser = "uid=portal.reset.user,ou=ServiceAccounts,o=nyit.edu,o=isp"
    @bindpass = 'JuZ3mE4n0w'
    
    @ldapconn = nil
    
    def init	
      
      @ldapconn = LDAP::Conn.new("ldap.nyit.edu", 389)
      @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
      @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
      @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
      @ldapconn.bind("uid=portal.reset.user,ou=ServiceAccounts,o=nyit.edu,o=isp","JuZ3mE4n0w")
      
    end
    
    def retrieve_user(employeenumber)
      
      raise ArgumentError, "employeenumber blank", caller if employeenumber != nil && employeenumber.empty? 
      
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
      
      xn = ProvXn.new      
      
      xn.username = retrievediplanetuser['uid']
      xn.employeenumber = retrievediplanetuser['employeeNumber']
      xn.familyname = retrievediplanetuser['sn']
      xn.givenname = retrievediplanetuser['givenName']
      (retrievediplanetuser['inetUserStatus'].to_s == "inactive" || retrievediplanetuser['userclass'].to_s == "separated") ? xn.suspended = 1 : xn.suspended = 0
      
      return xn
      
    end
    
    def create_user(user)
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
      #
      
    end
    
    #
    # preconditions: provxn has employeeid, username, password
    #
    # postconditions: user's password is updated in iplanet
    #
    def update_user(provxn)
      
      # raise ArgumentError, "malformed user", caller if olduser == nil || newuser == nil

      # raise ArgumentError, "password is nil", caller if provxn.password == nil

      #  
      # 
      # 

      #puts "This user is being modified:"
      #puts @retrieveduser['dn']
      
      #modifieduser = Hash.new
      #modifieduser['userpassword'] = ['testpassword']
      
      #puts modifieduser.inspect
      
      # MODIFY DEEZ DN
      #begin
      #ldapconn.modify(@retrieveduser['dn'].to_s, modifieduser)
      #	rescue LDAP::ResultError
      #		ldapconn.perror("modify")
      #		exit
      #end
      #ldapconn.perror("modify")
      
   
      #
      
    end
    
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
    end
    
  end
  
end # module
