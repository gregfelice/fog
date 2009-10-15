=begin

general value object for provisioning communications. supports ldap, AD, and google.

=end
module Provisioner
  
  class UserEntry
    
    attr_accessor :lastname, :firstname, :username, :password

  end
  
end
