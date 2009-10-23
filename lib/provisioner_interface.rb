require 'provisioner_exception'

module Provisioner

  class SuspendedUserException < ProvisionerException; end

  class ProvisionerInterface
    
    def create_user(prov_xn)
      raise NotImplementedError
    end
    
    def retrieve_user(employeenumber)
      raise NotImplementedError
    end
    
    def update_user(prov_xn)
      raise NotImplementedError
    end

    def update_user_attributes(attributes)
      raise NotImplementedError
    end
    
    def delete_user(employeenumber) 
      raise NotImplementedError
    end

  end
end
