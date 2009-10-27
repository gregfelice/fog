require 'provisioner_exception'

module Provisioner

  class SuspendedUserException < ProvisionerException; end

  class ProvisionerInterface
    
    @@field_map = { 
      'google'=> {
        'username' => 'username',
        'password' => 'password',
        'employeenumber' => nil,
        'familyname' => 'familyname',
        'givenname' => 'givenname',
        'suspended' => 'suspended',
        'userclass' => nil,
        'mailhost' => nil,
        'adadmindn' => nil,
        'iplanetdn' => nil
      }, 
      'iplanet' => {
        'username' => 'uid',
        'password' => 'userpassword',
        'employeenumber' => 'employeenumber',
        'familyname' => 'sn',
        'givenname' => 'givenname',
        'suspended' => nil,
        'userclass' => nil,
        'mailhost' => nil,
        'adadmindn' => nil,
        'iplanetdn' => nil
      }, 
      'adadmin' => {
        'username' => 'samaccountname',
        'password' => 'unicodepwd',
        'employeenumber' => 'employeeid',
        'familyname' => 'sn',
        'givenname' => 'givenname',
        'suspended' => 'useraccountcontrol',
        'userclass' => nil,
        'mailhost' => nil,
        'adadmindn' => nil,
        'iplanetdn' => nil
      }
    }

    def self.field_map
      return @@field_map
    end
    
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
