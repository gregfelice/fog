require 'provisioner_exception'

module Provisioner

  class SuspendedUserException < ProvisionerException; end

  class ProvisionerInterface
    
    def create_user()
      raise NotImplementedError
    end
    
    def retrieve_user(user_name)
      raise NotImplementedError
    end
    
    def update_user()
      raise NotImplementedError
    end
    
    def delete_user(user_name) 
      raise NotImplementedError
    end
    
  end

end
