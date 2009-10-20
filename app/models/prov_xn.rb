
require 'provisioner_google'
require 'provisioner_iplanet'
require 'object_not_found_exception'

class ProvXn < ActiveRecord::Base

  #
  # staff/faculty will be in ldap AND ad
  # students will be in ldap AND google.
  #
  # get from ldap (pk: employeenumber)
  # dump: https://nyitfu.nyit.edu/userfu/dump_ldap.php?search=gfelice
  #
  def self.find(employeenumber)
    
    logger.debug("ProvXn.find(): passed employeenumber of #{employeenumber}")
    
    p_iplanet = Provisioner::ProvisionerIplanet.new
    p_iplanet.init

    usr_iplanet = p_iplanet.retrieve_user(employeenumber)
    
    logger.debug("user_iplanet: #{usr_iplanet}")

    return usr_iplanet
  end

  # override
  def save
    raise NotImplementedError
  end

  #
  # override of activerecord implementation.
  #
  # save password change to all three provisioning systems.
  #
  def update

    begin 
      
      p_goog = Provisioner::ProvisionerGoogle.new
      p_goog.init
      
      p_iplanet = Provisioner::ProvisionerIplanet.new
      p_iplanet.init
      
      # p_ad = Provisioner::ProvisionerActiveDirectory.new
      # p_ad.init
      
      # retireve username pk from ldap for the google update
      returned_usr = p_iplanet.retrieve_user(self.employeenumber)
      self.username = returned_usr.username
      
      p_iplanet.update_user(self)
      # p_ad.update_user(self)
      p_goog.update_user(self)

      return true
      
    rescue Provisioner::ObjectNotFoundException
      
      self.errors.add("Update: ObjectNotFoundException: " + $!)
      
      return false
      
    rescue
      
      self.errors.add("Update: Unhandled Exception: " + $!)
      
      return false

    end
        
  end
  
  # override
  def destroy
    raise NotImplementedError
  end


  private 
  
end

