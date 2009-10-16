
require 'ldap'

require 'provisioner_interface'
require 'provisioner_exception'
require 'object_not_found_exception'

=begin

=end
module Provisioner

  class ProvisionerIplanet < ProvisionerInterface

    @HOST =    'ldap1.nyit.edu'
    @PORT =    LDAP::LDAP_PORT
    @SSLPORT = LDAP::LDAPS_PORT
    
    @base = 'ou=people, o=nyit.edu, o=isp'
    @scope = LDAP::LDAP_SCOPE_SUBTREE
    @filter = '(uid=dwohlt2)'
    @attrs = ['sn','cn','givenname','employeenumber','userclass','userpassword']
    @binduser = 'uid=portal.reset.user,ou=ServiceAccounts,o=nyit.edu,o=isp'
    @bindpass = 'JuZ3mE4n0w'
    
    public
    
    def init

      @ldapconn = LDAP::Conn.new($HOST, $PORT)
      @ldapconn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
      @ldapconn.set_option( LDAP::LDAP_OPT_SIZELIMIT, 999 )
      @ldapconn.set_option( LDAP::LDAP_OPT_TIMELIMIT, 60 )
      @ldapconn.bind(binduser,bindpass)

    end
    
    def retrieve_user(employeenumber)
      
      raise ArgumentError, "username blank", caller if username.empty? 

      begin
        entries = ldapconn.search2(base, scope, filter, attrs)

        raise ManyResultsReturnedException, "more than one row returned!!!", caller if ! entries.length.equal?(1)

        entries.each {|entry| @retrieveduser = entry}

        xn = ProvXn.new      

#
#
#
#
        xn.givenname = feed.elements["//apps:name"].attributes["givenName"]
        xn.familyname = feed.elements["//apps:name"].attributes["familyName"]
        xn.username = feed.elements["//apps:login"].attributes["userName"]
#
#
#       
 

        
        #else
        #raise ArgumentError, "More or less than 1 user found"
        #end
        
      rescue LDAP::ResultError
        ldapconn.perror("search")
        exit
      end

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
      
      raise ArgumentError, "malformed user", caller if olduser == nil || newuser == nil

      raise ArgumentError, "password is nil", caller if provxn.password == nil

      #  
      # 
      # 

      puts "This user is being modified:"
      puts @retrieveduser['dn']
      
      modifieduser = Hash.new
      modifieduser['userpassword'] = ['testpassword']
      
      puts modifieduser.inspect
      
      # MODIFY DEEZ DN
      #begin
      #ldapconn.modify(@retrieveduser['dn'].to_s, modifieduser)
      #	rescue LDAP::ResultError
      #		ldapconn.perror("modify")
      #		exit
      #end
      #ldapconn.perror("modify")
      
      ldapconn.unbind      
      #
      
    end
    
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
    end
    
  end
  
end # module
