
require 'provisioner_interface'
require 'common/user_entry'
require 'provisioner_exception'
require 'object_not_found_exception'

require 'provisioner/common/util'

=begin

=end
module Provisioner

  class ProvisionerLdap < ProvisionerInterface
    
    public
    
    def init
  
    end
    
    
    def retrieve_user(username)
      
      raise ArgumentError, "username blank", caller if username.empty? 

      #return user
      
    end
    
    def create_user(user)
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
      #
      
    end
    
    def update_user(olduser, newuser)
      
      raise ArgumentError, "malformed user", caller if olduser == nil || newuser == nil
      
      #
      
    end
    
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 
      
    end
    
  end
  
end # module
