
require 'provisioner_google'
require 'provisioner_iplanet'

class ProvXn < ActiveRecord::Base

  #
  # pk is empno
  #
  def self.find(employeenumber)
    
    logger.debug("ProvXn.find(): passed uid of #{id}")
    
    # staff/faculty will be in ldap AND ad
    # students will be in ldap AND google.
    
    # get from ldap (pk: employeenumber)
    # https://nyitfu.nyit.edu/userfu/dump_ldap.php?search=gfelice
    p_iplanet = Provisioner::ProvisionerIplanet.new
    usr_iplanet = p_iplanet.retrieve_user(id)
    
    # get from AD (pk: username)
    # https://nyitfu.nyit.edu/userfu/dump_ad.php?search=gfelice
    #p_ad = Provisioner::ProvisionerAd.new
    #usr_ad = p_ad.retrieve_user(id)
    
    # get from google (pk: username)
    #p_goog = get_google_provisioner
    #p_goog.retrieve_user(id)

    return usr_iplanet
  end

  # override
  def save
    raise NotImplementedError
  end

  # override of activerecord implementation.
  #
  # save password change to all three provisioning systems.
  #
  def update

    p_goog = ProvXn.get_google_provisioner
    p_goog.update_user(self)

    #p_goog = ProvXn.get_google_provisioner
    #p_goog.update_user(self)

    #p_goog = ProvXn.get_google_provisioner
    #p_goog.update_user(self)

  end
  
  # override
  def destroy
    raise NotImplementedError
  end


  private 

  def self.get_google_provisioner
    p_goog = Provisioner::ProvisionerGoogle.new
    p_goog.init
    return p_goog
  end
  
end

